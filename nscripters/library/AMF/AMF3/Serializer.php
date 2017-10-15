<?php

    require_once __DIR__.'/../AMF3/Const.php';
    require_once __DIR__.'/../Const.php';
    require_once __DIR__.'/../Serializer.php';
    require_once __DIR__.'/../ITypedObject.php';
    require_once __DIR__.'/../ByteArray.php';

    /**
     * NScripters_AMF3_Serializer
     * 
     * @package SabreAMF
     * @subpackage AMF3
     * @version $Id: Serializer.php 233 2009-06-27 23:10:34Z evertpot $
     * @copyright Copyright (C) 2006-2009 Rooftop Solutions. All rights reserved.
     * @author Evert Pot (http://www.rooftopsolutions.nl/) 
     * @author Karl von Randow http://xk72.com/
     * @author Develar
     * @licence http://www.freebsd.org/copyright/license.html  BSD License (4 Clause)
     * @uses NScripters_Const
     * @uses NScripters_AMF3_Const
     * @uses NScripters_ITypedObject
     */
    class NScripters_AMF3_Serializer extends NScripters_Serializer {

        /**
         * writeAMFData 
         * 
         * @param mixed $data 
         * @param int $forcetype 
         * @return mixed 
         */
        public function writeAMFData($data,$forcetype=null) {

           if (is_null($forcetype)) {
               // Autodetecting data type
               $type=false;
               if (!$type && is_null($data))    $type = NScripters_AMF3_Const::DT_NULL;
               if (!$type && is_bool($data))    {
                    $type = $data?NScripters_AMF3_Const::DT_BOOL_TRUE:NScripters_AMF3_Const::DT_BOOL_FALSE;
                }
                if (!$type && is_int($data)) {
                    // We essentially only got 29 bits for integers
                    if ($data > 0xFFFFFFF || $data < -268435456) {
                        $type = NScripters_AMF3_Const::DT_NUMBER;
                    } else {
                        $type = NScripters_AMF3_Const::DT_INTEGER;
                    }
                }
                if (!$type && is_float($data))   $type = NScripters_AMF3_Const::DT_NUMBER;
                if (!$type && is_int($data))     $type = NScripters_AMF3_Const::DT_INTEGER;
                if (!$type && is_string($data))  $type = NScripters_AMF3_Const::DT_STRING;
                if (!$type && is_array($data))   $type = NScripters_AMF3_Const::DT_ARRAY;
                if (!$type && is_object($data)) {

                    if ($data instanceof NScripters_ByteArray)
                        $type = NScripters_AMF3_Const::DT_BYTEARRAY;
                    elseif ($data instanceof DateTime) 
                        $type = NScripters_AMF3_Const::DT_DATE;
                    else 
                        $type = NScripters_AMF3_Const::DT_OBJECT;
                    

                }
                if ($type===false) {
                    throw new Exception('Unhandled data-type: ' . gettype($data));
                    return null;
                }
                if ($type == NScripters_AMF3_Const::DT_INTEGER && ($data > 268435455 || $data < -268435456)) {
                    $type = NScripters_AMF3_Const::DT_NUMBER;
                }
           } else $type = $forcetype;

           $this->stream->writeByte($type);

           switch ($type) {

                case NScripters_AMF3_Const::DT_NULL        : break;
                case NScripters_AMF3_Const::DT_BOOL_FALSE  : break;
                case NScripters_AMF3_Const::DT_BOOL_TRUE   : break;
                case NScripters_AMF3_Const::DT_INTEGER     : $this->writeInt($data); break;
                case NScripters_AMF3_Const::DT_NUMBER      : $this->stream->writeDouble($data); break;
                case NScripters_AMF3_Const::DT_STRING      : $this->writeString($data); break;
                case NScripters_AMF3_Const::DT_DATE        : $this->writeDate($data); break;
                case NScripters_AMF3_Const::DT_ARRAY       : $this->writeArray($data); break;
                case NScripters_AMF3_Const::DT_OBJECT      : $this->writeObject($data); break;
                case NScripters_AMF3_Const::DT_BYTEARRAY   : $this->writeByteArray($data); break;
                default                   :  throw new Exception('Unsupported type: ' . gettype($data)); return null; 
 
           }

        }

        /**
         * writeObject 
         * 
         * @param mixed $data 
         * @return void
         */
        public function writeObject($data) {
           
            $encodingType = NScripters_AMF3_Const::ET_PROPLIST;
            if ($data instanceof NScripters_ITypedObject) {

                $classname = $data->getAMFClassName();
                $data = $data->getAMFData();

            } else if (!$classname = $this->getRemoteClassName(get_class($data))) {

                
                $classname = '';

            } else {

                if ($data instanceof NScripters_Externalized) {

                    $encodingType = NScripters_AMF3_Const::ET_EXTERNALIZED;

                }

            }


            $objectInfo = 0x03;
            $objectInfo |= $encodingType << 2;

            switch($encodingType) {

                case NScripters_AMF3_Const::ET_PROPLIST :

                    $propertyCount=0;
                    foreach($data as $k=>$v) {
                        $propertyCount++;
                    }

                    $objectInfo |= ($propertyCount << 4);


                    $this->writeInt($objectInfo);
                    $this->writeString($classname);
                    foreach($data as $k=>$v) {

                        $this->writeString($k);

                    }
                    foreach($data as $k=>$v) {

                        $this->writeAMFData($v);

                    }
                    break;

                case NScripters_AMF3_Const::ET_EXTERNALIZED :

                    $this->writeInt($objectInfo);
                    $this->writeString($classname);
                    $this->writeAMFData($data->writeExternal());
                    break;
            }

        }

        /**
         * writeInt 
         * 
         * @param int $int 
         * @return void
         */
        public function writeInt($int) {

    			// Note that this is simply a sanity check of the conversion algorithm;
    			// when live this sanity check should be disabled (overflow check handled in this.writeAMFData).
    			/*if ( ( ( $int & 0x70000000 ) != 0 ) && ( ( $int & 0x80000000 ) == 0 ) )
    				throw new Exception ( 'Integer overflow during Int32 to AMF3 conversion' );*/

    			if ( ( $int & 0xffffff80 ) == 0 )
    			{
    				$this->stream->writeByte ( $int & 0x7f );

    				return;
    			}

    			if ( ( $int & 0xffffc000 ) == 0 )
    			{
    				$this->stream->writeByte ( ( $int >> 7 ) | 0x80 );
    				$this->stream->writeByte ( $int & 0x7f );

    				return;
    			}

    			if ( ( $int & 0xffe00000 ) == 0 )
    			{
    				$this->stream->writeByte ( ( $int >> 14 ) | 0x80 );
    				$this->stream->writeByte ( ( $int >> 7 ) | 0x80 );
    				$this->stream->writeByte ( $int & 0x7f );

    				return;
    			}

    			$this->stream->writeByte ( ( $int >> 22 ) | 0x80 );
    			$this->stream->writeByte ( ( $int >> 15 ) | 0x80 );
    			$this->stream->writeByte ( ( $int >> 8 ) | 0x80 );
    			$this->stream->writeByte ( $int & 0xff );

    			return;
        }

        public function writeByteArray(NScripters_ByteArray $data) {

            $this->writeString($data->getData());

        }

        /**
         * writeString 
         * 
         * @param string $str 
         * @return void
         */
        public function writeString($str) {

            $strref = strlen($str) << 1 | 0x01;
            $this->writeInt($strref);
            $this->stream->writeBuffer($str);

        }

        /**
         * writeArray 
         * 
         * @param array $arr 
         * @return void
         */
        public function writeArray(array $arr) {

            end($arr);

            // We need to split up strings an numeric array keys
            $num = array();
            $string = array();
            foreach($arr as $k=>$v) {
                if (is_int($k)) $num[] = $v; else $string[$k] = $v;
            }

            unset($arr);

            // Writing the length for the numeric keys in the array
            $arrLen = count($num); 
            $arrId = ($arrLen << 1) | 0x01;

            $this->writeInt($arrId);

            foreach($string as $key=>$v) {
                $this->writeString($key);
                $this->writeAMFData($v);
            }
            $this->writeString("");
           
            foreach($num as $v) {
                $this->writeAMFData($v);
            }

        }
        
        /**
         * Writes a date object 
         * 
         * @param DateTime $data 
         * @return void
         */
        public function writeDate(DateTime $data) {

            // We're always sending actual date objects, never references
            $this->writeInt(0x01);
            $this->stream->writeDouble($data->format('U')*1000);

        }

    }


