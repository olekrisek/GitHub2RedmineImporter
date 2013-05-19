<?php
// Github Details

function gitdate2mysql ($datex) {
	fb($datex, "Verdi inn"); 
	$d = str_replace("T", " ", $datex); 
	$d = str_replace("Z", "", $d); 
	fb($d, "Verdi ut"); 
	return $d; 
}
//function fb() {}
fb('In'); 
if (!defined('GITTEST') or !constant('GITTEST')) 
	die('Direct access not allowed!');
	
fb('in2'); 	
$github_org = '--Org Name-- '; //Github Organisation Name
$github_repo = '-- Repository name--'; //Github Repository Name
fb("Before access token"); 
if (!isset($_SESSION['access_token']))
	die("Ikke funnet access token..."); 
fb("After access token"); 
$access_token = $_SESSION['access_token']; 

 
// Get from Github
// For closed Issues, change open to closed in the next line, uncomment $closed below (2 places), and change status-ID from 1 to 5. 
// Separate run for opened and closed issues. 
// Separate run for each individual page needed for all pages. 
$getPar = array ('access_token' => $access_token, 
				'state' => 'closed', 
				'per_page' => 100, 
				'page' => 1 
				); 
$gitURL = "https://api.github.com/repos/$github_org/$github_repo/issues"; 
$fieldstring = http_build_query($getPar); 

// $issues_url = "https://api.github.com/repos/$github_org/$github_repo/issues?state=open?per_page=100";
fb($issues_url); 
fb($_POST); 
fb($_GET); 

 // Use CURL instead....
 
 
 $ch = curl_init();
 // User-Agent: bow-github (bow-github api v0.1.0) (http://bowc.programdesign.no/gt)
 //set the url, number of POST vars, POST data
 curl_setopt($ch,CURLOPT_URL, $gitURL.'?'.$fieldstring);
 curl_setopt($ch,CURLOPT_HTTPGET, true);
 curl_setopt($ch,CURLOPT_RETURNTRANSFER, true);
 curl_setopt($ch,CURLOPT_USERAGENT, 'bow-github (bow-github api v0.1.0) (http://bowc.programdesign.no/gt)');

 //curl_setopt($ch,CURLOPT_POSTFIELDS, $fieldstring);
 fb("Before execute"); 
 //execute post
 $result = curl_exec($ch);
 //close connection
 curl_close($ch);
 
 
 
  
$data = json_decode( $result, true );
fb($data);  

//----------------------------------------------------------------------------
// Comment out below when you see that you actually get data from GitHub....

exit(1); 
die("Completed"); 
 
// Push to Redmine

require_once($thispath."../db/mySqli_bowc.php");

$db = new mysqli_bowc ('redmine-host.com','redmine','passwd','redmine'); 
// edit /etc/my.cnf to have bind = 0.0.0.0 and restart mysqld before run. Remove after import and restart again. 

// Alle brukere som har lagt inn/kommentert på issues på GitHub må være opprettet her. Sjekk ID ved å se på lenker på lokale brukere. 
// GITHUB user table: Alle brukere må ha en entry her, med korresponderende bruker-ID i redmine. 
 
$gitusers = array ('user-one' => 4, 
					'user-two' => 5, 
					'user-there' => 1, 
					'user-four' => 7); 
		// '2013-04-17T11:54:24Z'			
$nl = "\r"; 
foreach ( $data as $row ) {
    $subject = $row['title'];
    $description = $row['body'];
    $description .= "\r----------------------------------\r"; 
    $description .= "On Github: ".$row['html_url']."\r";
    if (isset($row['milestone']['number'])) {
    	$description .= "Milestone(".$row['milestone']['number']."): ".$row['milestone']['title']."\r";
    }
   
    $labels = ""; 
    foreach($row['labels'] as $labrow) {
    	$labels .= $labrow ['name'].", "; 
    }
    if ($labels != "") {
    	$labels = rtrim($labels, ", "); 
    	$description .= $labels; 
    }
    
    
    
    $userID = 0; 
    $user = $row['user']['login']; 
    fb($user, "User: "); 
  	$userID = $gitusers[$user];  
    fb($userID, "UserID"); 
    $description .= $nl."Git Issue Number: ".$row['number'].$nl; 
    $closed = gitdate2mysql($row['closed_at']); 
    $created = gitdate2mysql($row['created_at']); 
    $updated = gitdate2mysql($row['updated_at']); 
    $startDate = substr($created, 0, 10); 
    
 // Proposed change: 
 // replace (http to !http and any png), PNG), JPG), jpg) to have ! instead of ). 
 // this will show pictures inline in messages. 
 // To also be done in comments....
    $gitNumber = $row['number']; 
    
    $issueArr = array(
    	'subject' => $subject, 
    	'description' =>  $description, 
    	'project_id' => 2, // put correct project ID here. 
    	'author_id' => $userID, 
    	'created_on' => $created, 
    	'updated_on' => $updated, 
    	'closed_on' => $closed, 
    	'start_date' => $startDate, 
    	'priority_id' => 2, 
    	'status_id' => 5, 
    	'tracker_id' => 4, 
    	'lft' => 1, 
    	'rgt' => 2, 
    	'GitIssueNr' => $gitNumber
    	); 
    
    $asignedID = 0; 
    if (count($row['assignee'])) {
    	$asigned = $row['assignee']['login']; 
    	if (isset($gitusers[$asigned])) 
    		$issueArr['assigned_to_id'] = $gitusers[$asigned];  
    }
    fb($issueArr); // 
    
    
    
    $res = $db
    ->prepare() 
    ->insert('issues', $issueArr); 
    
    $issue_id = $res;
    $upd2 = array ('root_id' => $res, 
    				'lft' => 2*$res-1, 
    				'rgt' => 2*$res); 
    // UPDATE `redmine`.`projects` SET lft = 2 * id - 1, rgt = 2 * id;
    // http://www.redmine.org/issues/6579
    $res2 = $db
    ->prepare()
    ->where ('id', $res)
    ->update('issues', $upd2); 
    
   
     
    // Add comments as updates
    if ($row['comments'] > 0 ) {
        $xissueNr = $row['number'];
        $comment_url = "https://api.github.com/repos/$github_org/$github_repo/issues/$xissueNr/comments";
         
         $getPar = array ('access_token' => $access_token); 
         
         $fieldstring = http_build_query($getPar); 
         
         
         $ch = curl_init();
          // User-Agent: bow-github (bow-github api v0.1.0) (http://bowc.programdesign.no/gt)
          //set the url, number of POST vars, POST data
          curl_setopt($ch,CURLOPT_URL, $comment_url.'?'.$fieldstring);
          curl_setopt($ch,CURLOPT_HTTPGET, true);
          curl_setopt($ch,CURLOPT_RETURNTRANSFER, true);
          curl_setopt($ch,CURLOPT_USERAGENT, 'bow-github (bow-github api v0.1.0) (http://bowc.programdesign.no/gt)');
         
          //curl_setopt($ch,CURLOPT_POSTFIELDS, $fieldstring);
          fb("Before execute"); 
          //execute post
          $resultComment = curl_exec($ch);
          //close connection
          curl_close($ch);
          
         
      //  $json2 = file_get_contents( $resultComment );
        $comments = json_decode( $resultComment, true );
 
        foreach ( $comments as $comment_row ) {
            $comment_notes = $comment_row['body'];
            // Proposed change: 
            // replace (http to !http and any png), PNG), JPG), jpg) to have ! instead of ). 
            // this will show pictures inline in messages. 
            // To also be done in comments....
               
            $commentID = $comment_row['id'];
            $commNote = array (
            	'notes' => $comment_notes, 
            	'user_id' => $gitusers[$comment_row['user']['login']], 
            	'journalized_id' => $issue_id, 
            	'created_on' => gitdate2mysql($comment_row['created_at']), 
            	'journalized_type' => "Issue", 
            	'GitCommentID' => $commentID
            ); 
            $res = $db
            ->prepare()
            ->insert('journals', $commNote); 
             
            $html .= 'Comment added';
        }
    }
}
echo $html; 
?>