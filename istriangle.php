	<?PHP
$A = array(10,50,5,1);
 echo triangle($A);

function triangle($A){
	sort($A);
	for($i=0;$i<count($A)-2;$i++){
		if(($A[$i] + $A[$i+1]) > $A[$i+2]) return 1;
	
	}
return 0;
}