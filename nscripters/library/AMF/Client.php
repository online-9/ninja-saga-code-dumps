<?php


    require_once __DIR__.'/Message.php';
    require_once __DIR__.'/OutputStream.php';
    require_once __DIR__.'/InputStream.php';
    require_once __DIR__.'/Const.php';
    require_once __DIR__.'/AMF3/Wrapper.php';

    /**
     * AMF Client
     *
     * Use this class to make a calls to AMF0/AMF3 services. The class makes use of the curl http library, so make sure you have this installed.
     *
     * It sends AMF0 encoded data by default. Change the encoding to AMF3 with setEncoding. sendRequest calls the actual service 
     * 
     * @package SabreAMF
     * @version $Id: Client.php 233 2009-06-27 23:10:34Z evertpot $
     * @copyright Copyright (C) 2006-2009 Rooftop Solutions. All rights reserved.
     * @author Evert Pot (http://www.rooftopsolutions.nl/) 
     * @licence http://www.freebsd.org/copyright/license.html  BSD License
     * @example ../examples/client.php
     * @uses NScripters_Message
     * @uses NScripters_OutputStream
     * @uses NScripters_InputStream
     */
    class NScripters_Client {

        /**
         * endPoint 
         * 
         * @var string 
         */
        private $endPoint;
        /**
         * httpProxy
         * 
         * @var mixed
         */
        private $httpProxy;
        /**
         * amfInputStream 
         * 
         * @var NScripters_InputStream
         */
        private $amfInputStream;
        /**
         * amfOutputStream 
         * 
         * @var NScripters_OutputStream
         */
        private $amfOutputStream;

        /**
         * amfRequest 
         * 
         * @var NScripters_Message
         */
        private $amfRequest;

        /**
         * amfResponse 
         * 
         * @var NScripters_Message
         */
        private $amfResponse;

        /**
         * encoding 
         * 
         * @var int 
         */
        private $encoding = NScripters_Const::AMF0;

        /**
         * __construct 
         * 
         * @param string $endPoint The url to the AMF gateway
         * @return void
         */
        public function __construct($endPoint) {

            $this->endPoint = $endPoint;

            $this->amfRequest = new NScripters_Message();
            $this->amfOutputStream = new NScripters_OutputStream();

        }


        /**
         * sendRequest 
         *
         * sendRequest sends the request to the server. It expects the servicepath and methodname, and the parameters of the methodcall
         * 
         * @param string $servicePath The servicepath (e.g.: myservice.mymethod)
         * @param array $data The parameters you want to send
         * @return mixed 
         */
        public function sendRequest($servicePath,$data) {
           
            // We're using the FLEX Messaging framework
            if($this->encoding & NScripters_Const::FLEXMSG) {


                // Setting up the message
                $message = new NScripters_AMF3_RemotingMessage();
                $message->body = $data;

                // We need to split serviceName.methodName into separate variables
                $service = explode('.',$servicePath);
                $method = array_pop($service);
                $service = implode('.',$service);
                $message->operation = $method; 
                $message->source = $service;

                $data = $message;
            }

            $this->amfRequest->addBody(array(

                // If we're using the flex messaging framework, target is specified as the string 'null'
                'target'   => $this->encoding & NScripters_Const::FLEXMSG?'null':$servicePath,
                'response' => '/1',
                'data'     => $data
            ));

            $this->amfRequest->serialize($this->amfOutputStream);

            // The curl request
            $ch = curl_init($this->endPoint);
            curl_setopt($ch,CURLOPT_POST,1);
            curl_setopt($ch,CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($ch,CURLOPT_TIMEOUT,20);
            curl_setopt($ch,CURLOPT_HTTPHEADER,array('Content-type: ' . NScripters_Const::MIMETYPE));
            curl_setopt($ch,CURLOPT_POSTFIELDS,$this->amfOutputStream->getRawData());
    		if ($this->httpProxy) {
    			curl_setopt($ch,CURLOPT_PROXY,$this->httpProxy);
    		}
            $result = curl_exec($ch);
 
            if (curl_errno($ch)) {
                throw new Exception('CURL error: ' . curl_error($ch));
                false;
            } else {
                curl_close($ch);
            }
       
            $this->amfInputStream = new NScripters_InputStream($result);
            $this->amfResponse = new NScripters_Message();
            $this->amfResponse->deserialize($this->amfInputStream);

            $this->parseHeaders();

            foreach($this->amfResponse->getBodies() as $body) {

                if (strpos($body['target'],'/1')===0) return $body['data'] ;

            }

        }

        /**
         * addHeader 
         *
         * Add a header to the client request
         * 
         * @param string $name 
         * @param bool $required 
         * @param mixed $data 
         * @return void
         */
        public function addHeader($name,$required,$data) {

            $this->amfRequest->addHeader(array('name'=>$name,'required'=>$required==true,'data'=>$data));

        }
       
        /**
         * setCredentials 
         * 
         * @param string $username 
         * @param string $password 
         * @return void
         */
        public function setCredentials($username,$password) {

            $this->addHeader('Credentials',false,(object)array('userid'=>$username,'password'=>$password));

        }
        
        /**
         * setHttpProxy
         * 
         * @param mixed $httpProxy
         * @return void
         */
        public function setHttpProxy($httpProxy) {
            $this->httpProxy = $httpProxy;
        }

        /**
         * parseHeaders 
         * 
         * @return void
         */
        private function parseHeaders() {

            foreach($this->amfResponse->getHeaders() as $header) {

                switch($header['name']) {

                    case 'ReplaceGatewayUrl' :
                        if (is_string($header['data'])) {
                            $this->endPoint = $header['data'];
                        }
                        break;

                }


            }

        }

        /**
         * Change the AMF encoding (0 or 3) 
         * 
         * @param int $encoding 
         * @return void
         */
        public function setEncoding($encoding) {

            $this->encoding = $encoding;
            $this->amfRequest->setEncoding($encoding & NScripters_Const::AMF3);

        }

    }



