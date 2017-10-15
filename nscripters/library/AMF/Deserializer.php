<?php

    /**
     * NScripters_Deserializer
     * 
     * @package SabreAMF 
     * @version $Id: Deserializer.php 233 2009-06-27 23:10:34Z evertpot $
     * @copyright Copyright (C) 2006-2009 Rooftop Solutions. All rights reserved.
     * @author Evert Pot (http://www.rooftopsolutions.nl/) 
     * @licence http://www.freebsd.org/copyright/license.html  BSD License (4 Clause) 
     */

    require_once __DIR__.'/ClassMapper.php';
    require_once __DIR__.'/InputStream.php';


    /**
     * NScripters_Deserializer
     * 
     * This is the abstract Deserializer. The AMF0 and AMF3 classes descent from this class
     */
    abstract class NScripters_Deserializer {

        /**
         * stream 
         * 
         * @var NScripters_InputStream
         */
        protected $stream;

        /**
         * __construct 
         *
         * @param NScripters_InputStream $stream
         * @return void
         */
        public function __construct(NScripters_InputStream $stream) {

            $this->stream = $stream;

        }

        /**
         * readAMFData 
         * 
         * Starts reading an AMF block from the stream
         * 
         * @param mixed $settype 
         * @return mixed 
         */
        public abstract function readAMFData($settype = null); 


        /**
         * getLocalClassName 
         * 
         * @param string $remoteClass 
         * @return mixed 
         */
        protected function getLocalClassName($remoteClass) {

            return NScripters_ClassMapper::getLocalClass($remoteClass);

        } 

   }


