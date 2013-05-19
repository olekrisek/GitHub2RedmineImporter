<?php

// OAuth token regime....
session_start();  // Start the PHP session...
function GetDefault($key, $default="") {
	if (isset($_GET[$key])) return $_GET[$key]; 
	else return $default; 
}

function GetDefaultPost($key, $default="") {
	if (isset($_POST[$key])) return $_POST[$key]; 
	else return $default; 
}
define ("STATECODE", "flyndre12436flesk"); 
define ("GITTEST", true); 
require_once('../lib/FirePHPCore/fb.php');
fb($_GET,'$_GET'); 
fb($_POST, '$_POST'); 
fb($_SERVER['REQUEST_METHOD'], "REQUEST_METHOD"); 
fb($_SESSION, "SESSION"); 

define("GH_ClentID", "--insert client ID here--"); 
define("GH_ClentSecret", "--insert client Secret here--"); 
define("URLThisScript","http://-url-to-this-script--"); 
 
//exit(1); 
//die('Avsluttet - jobben er kjørt, skal ikke kjøres en gang til...'); 
if (! isset($_SESSION['GITOK'])) {
	if ($_SERVER['REQUEST_METHOD'] == "POST") {
	
	
	
	}
	else {
	
		$code = GetDefault('code', "xx"); 
		fb($code); 
		if ($code == "xx") { // First stage authorize
			fb("Step 1..."); 
			// 1. Redirect user to github for accepting 
			$url1 = "https://github.com/login/oauth/authorize?"; 
			$parOne = array('client_id' => GH_ClentID, 
							'redirect_uri' => URLThisScript, 
							'scope' => 'repo', 
							'state' => STATECODE);
			
			$redir = $url1.http_build_query($parOne); 
			header("Location: ".$redir); 
			
			exit(1); 
			die('complete'); 
		} 
		 
// REDIRECT FROM GITHUB 
// --------------------------
		if (GetDefault('state' != STATECODE )) {
			fb("Wrong state code"); 
			die('Wrong state code'); 
		}
		 
		$parTwo = array ('client_id' => GH_ClentID, 
		'redirect_uri' => URLThisScript, 
		'client_secret' => GH_ClentSecret, 
		'code' => $code) ; 
		
		$url2 = 'https://github.com/login/oauth/access_token'; 
		$fieldstring = http_build_query($parTwo);
		$ch = curl_init();
		
		//set the url, number of POST vars, POST data
		curl_setopt($ch,CURLOPT_URL, $url2);
		curl_setopt($ch,CURLOPT_POST, true);
		curl_setopt($ch,CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch,CURLOPT_POSTFIELDS, $fieldstring);
		fb("Before execute"); 
		//execute post
		$result = curl_exec($ch);
		fb($result, "Resultat"); 
		//close connection
		curl_close($ch);
		
		$params = array(); 
		parse_str($result, $params) ; 
		fb($params); 
		if (isset($params['access_token'])) {
			$_SESSION['GITOK'] = true; 
			$_SESSION['access_token'] = $params['access_token']; 
		} else die('No access token'); 
	}
}
	
if ($_SESSION['GITOK']) {

	fb($_SESSION); 

	include('gittest.php'); 
}
				 



?>