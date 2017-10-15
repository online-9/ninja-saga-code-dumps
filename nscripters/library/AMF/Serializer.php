<?php

    /**
     * NScripters_Serializer
     * 
     * @package SabreAMF 
     * @version $Id: Serializer.php 233 2009-06-27 23:10:34Z evertpot $
     * @copyright Copyright (C) 2006-2009 Rooftop Solutions. All rights reserved.
     * @author Evert Pot (http://www.rooftopsolutions.nl/) 
     * @licence http://www.freebsd.org/copyright/license.html  BSD License (4 Clause) 
     */


    require_once __DIR__.'/ClassMapper.php';
    require_once __DIR__.'/OutputStream.php'; 

    /**
     * Abstract Serializer
     *
     * This is the abstract serializer class. This is used by the AMF0 and AMF3 serializers as a base class
     */
    abstract class NScripters_Serializer {

        /**
         * stream 
         * 
         * @var NScripters_OutputStream
         */
        protected $stream;

        /**
         * __construct 
         * 
         * @param NScripters_OutputStream $stream
         * @return void
         */
        public function __construct(NScripters_OutputStream $stream) {

            $this->stream = $stream;

        }

        /**
         * writeAMFData 
         * 
         * @param mixed $data 
         * @param int $forcetype 
         * @return mixed 
         */
        public abstract function writeAMFData($data,$forcetype=null); 

        /**
         * getStream
         *
         * @return NScripters_OutputStream
         */
        public function getStream() {

            return $this->stream;

        }

        /**
         * getRemoteClassName 
         * 
         * @param string $localClass 
         * @return mixed 
         */
        protected function getRemoteClassName($localClass) {

            return NScripters_ClassMapper::getRemoteClass($localClass);

        } 

    }


