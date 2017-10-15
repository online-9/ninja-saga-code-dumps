<?php

    require_once __DIR__.'/AMF0/Serializer.php'; 
    require_once __DIR__.'/AMF0/Deserializer.php'; 
    require_once __DIR__.'/Const.php';
    require_once __DIR__.'/AMF3/Wrapper.php';

    /**
     * NScripters_Message
     * 
     * The Message class encapsulates either an entire request package or an entire result package; including an AMF enveloppe
     * 
     * @package SabreAMF 
     * @version $Id: Message.php 233 2009-06-27 23:10:34Z evertpot $
     * @copyright Copyright (C) 2006-2009 Rooftop Solutions. All rights reserved.
     * @author Evert Pot (http://www.rooftopsolutions.nl/) 
     * @licence http://www.freebsd.org/copyright/license.html  BSD License (4 Clause)
     * @uses NScripters_AMF0_Serializer
     * @uses NScripters_AMF0_Deserializer
     */
    class NScripters_Message {

        /**
         * clientType
         *
         * @var int
         */
        private $clientType=0;
        /**
         * bodies 
         * 
         * @var array
         */
        private $bodies=array();
        /**
         * headers 
         * 
         * @var array
         */
        private $headers=array();

        /**
         * encoding 
         * 
         * @var int 
         */
        private $encoding = NScripters_Const::AMF0;

        /**
         * serialize 
         * 
         * This method serializes a request. It requires an NScripters_OutputStream as an argument to read
         * the AMF Data from. After serialization the Outputstream will contain the encoded AMF data.
         * 
         * @param NScripters_OutputStream $stream
         * @return void
         */
        public function serialize(NScripters_OutputStream $stream) {

            $this->outputStream = $stream;
            $stream->writeByte(0x00);
            $stream->writeByte($this->encoding);
            $stream->writeInt(count($this->headers));
            
            foreach($this->headers as $header) {

                $serializer = new NScripters_AMF0_Serializer($stream);
                $serializer->writeString($header['name']);
                $stream->writeByte($header['required']==true);
                $stream->writeLong(-1);
                $serializer->writeAMFData($header['data']);
            }

            $stream->writeInt(count($this->bodies));


            foreach($this->bodies as $body) {
                $serializer = new NScripters_AMF0_Serializer($stream);
                $serializer->writeString($body['target']);
                $serializer->writeString($body['response']);
                $stream->writeLong(-1);
                
                switch($this->encoding) {

                    case NScripters_Const::AMF0 :
                        $serializer->writeAMFData($body['data']);
                        break;
                    case NScripters_Const::AMF3 :
                        $serializer->writeAMFData(new NScripters_AMF3_Wrapper($body['data']));
                        break;

                }

            }

        }

        /**
         * deserialize 
         * 
         * This method deserializes a request. It requires an NScripters_InputStream with valid AMF data. After
         * deserialization the contents of the request can be found through the getBodies and getHeaders methods
         *
         * @param NScripters_InputStream $stream
         * @return void
         */
        public function deserialize(NScripters_InputStream $stream) {

            $this->headers = array();
            $this->bodies = array();

            $this->InputStream = $stream;

            $stream->readByte();
          
            $this->clientType = $stream->readByte();

            $deserializer = new NScripters_AMF0_Deserializer($stream);

            $totalHeaders = $stream->readInt();

            for($i=0;$i<$totalHeaders;$i++) {

                $header = array(
                    'name'     => $deserializer->readString(),
                    'required' => $stream->readByte()==true
                );
                $stream->readLong();
                $header['data']  = $deserializer->readAMFData(null,true);
                $this->headers[] = $header;    

            }
 
            $totalBodies = $stream->readInt();

            for($i=0;$i<$totalBodies;$i++) {

                try {
                    $target = $deserializer->readString();
                } catch (Exception $e) {
                    // Could not fetch next body.. this happens with some versions of AMFPHP where the body
                    // count isn't properly set. If this happens we simply stop decoding
                    break;
                }

                $body = array(
                    'target'   => $target,
                    'response' => $deserializer->readString(),
                    'length'   => $stream->readLong(),
                    'data'     => $deserializer->readAMFData(null,true)
                );
         
                if (is_object($body['data']) && $body['data'] instanceof NScripters_AMF3_Wrapper) {
                     $body['data'] = $body['data']->getData();
                     $this->encoding = NScripters_Const::AMF3;
                } else if (is_array($body['data']) && isset($body['data'][0]) && is_object($body['data'][0]) && $body['data'][0] instanceof NScripters_AMF3_Wrapper) {
                     $body['data'] = $body['data'][0]->getData();
                     $this->encoding = NScripters_Const::AMF3;
                }

                $this->bodies[] = $body;    

            }


        }

        /**
         * getClientType 
         * 
         * Returns the ClientType for the request. Check NScripters_Const for possible (known) values
         * 
         * @return int 
         */
        public function getClientType() {

            return $this->clientType;

        }

        /**
         * getBodies 
         * 
         * Returns the bodies int the message
         * 
         * @return array 
         */
        public function getBodies() {

            return $this->bodies;

        }

        /**
         * getHeaders 
         * 
         * Returns the headers in the message
         * 
         * @return array 
         */
        public function getHeaders() {

            return $this->headers;

        }

        /**
         * addBody 
         *
         * Adds a body to the message
         * 
         * @param mixed $body 
         * @return void 
         */
        public function addBody($body) {

            $this->bodies[] = $body;

        }

        /**
         * addHeader 
         * 
         * Adds a message header
         * 
         * @param mixed $header 
         * @return void
         */
        public function addHeader($header) {

            $this->headers[] = $header;

        }

        /**
         * setEncoding 
         * 
         * @param int $encoding 
         * @return void
         */
        public function setEncoding($encoding) {

            $this->encoding = $encoding;

        }

        /**
         * getEncoding 
         * 
         * @return int 
         */
        public function getEncoding() {

            return $this->encoding; 

        }

    }


