<?php

    require_once __DIR__.'/../AMF3/Const.php';
    require_once __DIR__.'/../Const.php';
    require_once __DIR__.'/../Serializer.php';
    require_once __DIR__.'/../AMF3/Serializer.php';
    require_once __DIR__.'/../AMF3/Wrapper.php';
    require_once __DIR__.'/../ITypedObject.php';

    /**
     * NScripters_AMF0_Serializer
     * 
     * @package SabreAMF
     * @subpackage AMF0
     * @version $Id: Serializer.php 233 2009-06-27 23:10:34Z evertpot $
     * @copyright Copyright (C) 2006-2009 Rooftop Solutions. All rights reserved.
     * @author Evert Pot (http://www.rooftopsolutions.nl/) 
     * @licence http://www.freebsd.org/copyright/license.html  BSD License (4 Clause)
     * @uses NScripters_Const
     * @uses NScripters_AMF0_Const
     * @uses NScripters_AMF3_Serializer
     * @uses NScripters_AMF3_Wrapper
     * @uses NScripters_ITypedObject
     */
    class NScripters_AMF0_Serializer extends NScripters_Serializer {

        /**
         * writeAMFData 
         * 
         * @param mixed $data 
         * @param int $forcetype 
         * @return mixed 
         */
        public function writeAMFData($data,$forcetype=null) {

           //If theres no type forced we'll try detecting it
           if (is_null($forcetype)) {
                $type=false;

                // NULL type
                if (!$type && is_null($data))    $type = NScripters_AMF0_Const::DT_NULL;

                // Boolean
                if (!$type && is_bool($data))    $type = NScripters_AMF0_Const::DT_BOOL;

                // Number
                if (!$type && (is_int($data) || is_float($data))) $type = NScripters_AMF0_Const::DT_NUMBER;

                // String (a long one)
                if (!$type && is_string($data) && strlen($data)>65536) $type = NScripters_AMF0_Const::DT_LONGSTRING;

                // Normal string
                if (!$type && is_string($data))  $type = NScripters_AMF0_Const::DT_STRING;

                // Checking if its an array
                if (!$type && is_array($data))   {

                    // Looping through the array to see if there are any
                    // non-numeric keys
                    foreach(array_keys($data) as $key) {
                        if (!is_numeric($key)) {
                            // There's a non-numeric key.. we'll make it a mixed
                            // array
                            $type = NScripters_AMF0_Const::DT_MIXEDARRAY;
                            break;
                        }
                    }

                    // Pure array
                    if (!$type) $type = NScripters_AMF0_Const::DT_ARRAY;
                }

                // Its an object
                if (!$type && is_object($data)) {

                    // If its an AMF3 wrapper.. we treat it as such
                    if ($data instanceof NScripters_AMF3_Wrapper) $type = NScripters_AMF0_Const::DT_AMF3;

                    else if ($data instanceof DateTime) $type = NScripters_AMF0_Const::DT_DATE;

                    // We'll see if its registered in the classmapper
                    else if ($this->getRemoteClassName(get_class($data))) $type = NScripters_AMF0_Const::DT_TYPEDOBJECT;

                    // Otherwise.. check if it its an TypedObject
                    else if ($data instanceof NScripters_ITypedObject) $type = NScripters_AMF0_Const::DT_TYPEDOBJECT;

                    // If everything else fails, its a general object
                    else $type = NScripters_AMF0_Const::DT_OBJECT;
                }

                // If everything failed, throw an exception
                if ($type===false) {
                    throw new Exception('Unhandled data-type: ' . gettype($data));
                    return null;
                }
           } else $type = $forcetype;

           $this->stream->writeByte($type);

           switch ($type) {

                case NScripters_AMF0_Const::DT_NUMBER      : return $this->stream->writeDouble($data);
                case NScripters_AMF0_Const::DT_BOOL        : return $this->stream->writeByte($data==true);
                case NScripters_AMF0_Const::DT_STRING      : return $this->writeString($data);
                case NScripters_AMF0_Const::DT_OBJECT      : return $this->writeObject($data);
                case NScripters_AMF0_Const::DT_NULL        : return true;
                case NScripters_AMF0_Const::DT_MIXEDARRAY  : return $this->writeMixedArray($data);
                case NScripters_AMF0_Const::DT_ARRAY       : return $this->writeArray($data);
                case NScripters_AMF0_Const::DT_DATE        : return $this->writeDate($data);
                case NScripters_AMF0_Const::DT_LONGSTRING  : return $this->writeLongString($data);
                case NScripters_AMF0_Const::DT_TYPEDOBJECT : return $this->writeTypedObject($data);
                case NScripters_AMF0_Const::DT_AMF3        : return $this->writeAMF3Data($data);
                default                   :  throw new Exception('Unsupported type: ' . gettype($data)); return false;
 
           }

        }

        /**
         * writeMixedArray 
         * 
         * @param array $data 
         * @return void
         */
        public function writeMixedArray($data) {

            $this->stream->writeLong(0);
            foreach($data as $key=>$value) {
                $this->writeString($key);
                $this->writeAMFData($value);
            }
            $this->writeString('');
            $this->stream->writeByte(NScripters_AMF0_Const::DT_OBJECTTERM);

        }

        /**
         * writeArray 
         * 
         * @param array $data 
         * @return void
         */
        public function writeArray($data) {

            if (!count($data)) {
                $this->stream->writeLong(0);
            } else {
                end($data);
                $last = key($data);
                $this->stream->writeLong($last+1);
                for($i=0;$i<=$last;$i++) {
                    $item = isset($data[$i])?$data[$i]:NULL;
                    $this->writeAMFData($item);
                }
            }

        }

        /**
         * writeObject 
         * 
         * @param object $data 
         * @return void
         */
        public function writeObject($data) {

            foreach($data as $key=>$value) {
                $this->writeString($key);
                $this->writeAmfData($value);
            }
            $this->writeString('');
            $this->stream->writeByte(NScripters_AMF0_Const::DT_OBJECTTERM);
            return true;

        }

        /**
         * writeString 
         * 
         * @param string $string 
         * @return void
         */
        public function writeString($string) {

            $this->stream->writeInt(strlen($string));
            $this->stream->writeBuffer($string);

        }

        /**
         * writeLongString 
         * 
         * @param string $string 
         * @return void
         */
        public function writeLongString($string) {

            $this->stream->writeLong(strlen($string));
            $this->stream->writeBuffer($string);

        }
       /**
         * writeTypedObject 
         * 
         * @param object $data 
         * @return void
         */
        public function writeTypedObject($data) {

            if ($data instanceof NScripters_ITypedObject) {
                    $classname = $data->getAMFClassName();
                $data = $data->getAMFData();
            } else $classname = $this->getRemoteClassName(get_class($data));

            $this->writeString($classname);
            return $this->writeObject($data);

        }


        /**
         * writeAMF3Data 
         * 
         * @param mixed $data 
         * @return void 
         */
        public function writeAMF3Data(NScripters_AMF3_Wrapper $data) {

            $serializer = new NScripters_AMF3_Serializer($this->stream);
            return $serializer->writeAMFData($data->getData());

        }

        /**
         * Writes a date object 
         * 
         * @param DateTime $data 
         * @return void
         */
        public function writeDate(DateTime $data) {

            $this->stream->writeDouble($data->format('U')*1000);

            // empty timezone
            $this->stream->writeInt(0);
        }

    }


