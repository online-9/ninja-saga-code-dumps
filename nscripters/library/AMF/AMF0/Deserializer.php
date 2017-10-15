<?php

    require_once __DIR__.'/../AMF0/Const.php';
    require_once __DIR__.'/../Const.php';
    require_once __DIR__.'/../Deserializer.php';
    require_once __DIR__.'/../AMF3/Deserializer.php';
    require_once __DIR__.'/../AMF3/Wrapper.php';
    require_once __DIR__.'/../TypedObject.php';

    /**
     * NScripters_AMF0_Deserializer
     * 
     * @package SabreAMF
     * @subpackage AMF0
     * @version $Id: Deserializer.php 233 2009-06-27 23:10:34Z evertpot $
     * @copyright Copyright (C) 2006-2009 Rooftop Solutions. All rights reserved.
     * @author Evert Pot (http://www.rooftopsolutions.nl/) 
     * @licence http://www.freebsd.org/copyright/license.html  BSD License (4 Clause) 
     * @uses NScripters_Const
     * @uses NScripters_AMF0_Const
     * @uses NScripters_AMF3_Deserializer
     * @uses NScripters_AMF3_Wrapper
     * @uses NScripters_TypedObject
     */
    class NScripters_AMF0_Deserializer extends NScripters_Deserializer {

        /**
         * refList 
         * 
         * @var array 
         */
        private $refList = array();

        /**
         * amf3Deserializer 
         * 
         * @var NScripters_AMF3_Deserializer
         */
        private $amf3Deserializer = null;

        /**
         * readAMFData 
         * 
         * @param int $settype 
         * @param bool $newscope
         * @return mixed 
         */
        public function readAMFData($settype = null,$newscope = false) {

           if ($newscope) $this->refList = array();

           if (is_null($settype)) {
                $settype = $this->stream->readByte();
           }

           switch ($settype) {

                case NScripters_AMF0_Const::DT_NUMBER      : return $this->stream->readDouble();
                case NScripters_AMF0_Const::DT_BOOL        : return $this->stream->readByte()==true;
                case NScripters_AMF0_Const::DT_STRING      : return $this->readString();
                case NScripters_AMF0_Const::DT_OBJECT      : return $this->readObject();
                case NScripters_AMF0_Const::DT_NULL        : return null;
                case NScripters_AMF0_Const::DT_UNDEFINED   : return null;
                case NScripters_AMF0_Const::DT_REFERENCE   : return $this->readReference();
                case NScripters_AMF0_Const::DT_MIXEDARRAY  : return $this->readMixedArray();
                case NScripters_AMF0_Const::DT_ARRAY       : return $this->readArray();
                case NScripters_AMF0_Const::DT_DATE        : return $this->readDate();
                case NScripters_AMF0_Const::DT_LONGSTRING  : return $this->readLongString();
                case NScripters_AMF0_Const::DT_UNSUPPORTED : return null;
                case NScripters_AMF0_Const::DT_XML         : return $this->readLongString();
                case NScripters_AMF0_Const::DT_TYPEDOBJECT : return $this->readTypedObject();
                case NScripters_AMF0_Const::DT_AMF3        : return $this->readAMF3Data();
                default                   :  throw new Exception('Unsupported type: 0x' . strtoupper(str_pad(dechex($settype),2,0,STR_PAD_LEFT))); return false;
 
           }

        }

        /**
         * readObject 
         * 
         * @return object 
         */
        public function readObject() {

            $object = array();
            $this->refList[] =& $object;
            while (true) {
                $key = $this->readString();
                $vartype = $this->stream->readByte();
                if ($vartype==NScripters_AMF0_Const::DT_OBJECTTERM) break;
                $object[$key] = $this->readAmfData($vartype);
            }
            if (defined('NScripters_OBJECT_AS_ARRAY')) {
                $object = (object)$object;
            }
            return $object;    

        }

        /**
         * readReference 
         * 
         * @return object 
         */
        public function readReference() {
            
            $refId = $this->stream->readInt();
            if (isset($this->refList[$refId])) {
                return $this->refList[$refId];
            } else {
                throw new Exception('Invalid reference offset: ' . $refId);
                return false;
            }

        }


        /**
         * readArray 
         * 
         * @return array 
         */
        public function readArray() {

            $length = $this->stream->readLong();
            $arr = array();
            $this->refList[]&=$arr;
            while($length--) $arr[] = $this->readAMFData();
            return $arr;

        }

        /**
         * readMixedArray 
         * 
         * @return array 
         */
        public function readMixedArray() {

            $highestIndex = $this->stream->readLong();
            return $this->readObject();

        }

       /**
         * readString 
         * 
         * @return string 
         */
        public function readString() {

            $strLen = $this->stream->readInt();
            return $this->stream->readBuffer($strLen);

        }

        /**
         * readLongString 
         * 
         * @return string 
         */
        public function readLongString() {

            $strLen = $this->stream->readLong();
            return $this->stream->readBuffer($strLen);

        }

        /**
         *  
         * readDate 
         * 
         * @return int 
         */
        public function readDate() {

            // Unix timestamp in seconds. We strip the millisecond part
            $timestamp = floor($this->stream->readDouble() / 1000);

            // we are ignoring the timezone
            $timezoneOffset = $this->stream->readInt();
            //if ($timezoneOffset > 720) $timezoneOffset = ((65536 - $timezoneOffset));
            //$timezoneOffset=($timezoneOffset * 60) - date('Z');

            $dateTime = new DateTime('@' . $timestamp);
            
            return $dateTime;

        }

        /**
         * readTypedObject 
         * 
         * @return object
         */
        public function readTypedObject() {

            $classname = $this->readString();

            $isMapped = false;

            if ($classname = $this->getLocalClassName($classname)) {
                $rObject = new $classname();
                $isMapped = true;
            } else {
                $rObject = new NScripters_TypedObject($classname,null);
            }
            $this->refList[] =& $rObject;

            $props = array();
            while (true) {
                $key = $this->readString();
                $vartype = $this->stream->readByte();
                if ($vartype==NScripters_AMF0_Const::DT_OBJECTTERM) break;
                $props[$key] = $this->readAmfData($vartype);
            }

            if ($isMapped) {
                foreach($props as $k=>$v) 
                    $rObject->$k = $v;
            } else {
                $rObject->setAMFData($props);
            }

            return $rObject;

        }
        
        /**
         * readAMF3Data 
         * 
         * @return NScripters_AMF3_Wrapper
         */
        public function readAMF3Data() {

            $amf3Deserializer = new NScripters_AMF3_Deserializer($this->stream);
            return new NScripters_AMF3_Wrapper($amf3Deserializer->readAMFData());

        }


   }


