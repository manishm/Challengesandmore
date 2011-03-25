<?PHP
$A = array(1,4,5);
 echo bitcountInTripled($A);

function bitcountInTripled($A)
 {
	$lastval=end($A);
	$newlength=$lastval;
	$newarray=array();
	
	//loops 3 times(finite-N)
	for($i=0;$i<=count($A);$i++){
		$newarray[$A[$i]] = 1;
	}	
	
	for($i=0;$i<=$newlength;$i++){
		if($newarray[$i]==null)$newarray[$i]=0;
	}
	
	for($i=count($newarray);$i>=0;$i--){
		$nostr.=$newarray[$i];
	}
    $K=bindec($nostr);
	
	
	$binK=decbin(3*$K);
	$revbinK=strrev($binK);
	$length=strlen($binK);
	
	for($i=0;$i<$length;$i++){
		if($revbinK[$i]=='1'){$count++;}
	}
	return $count;
	
}
?>