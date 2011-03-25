	<?PHP
$A = array(5, -3, -1, -10, -7, -6,100,1,-1.2);
 maxRS($A);

function maxRS( $A ) {
    
	$resultintarray=array();
	$max=0;
	$keymax=0;
	$count=1;
	$bool=true;
	$lastval=$A[0];
	$maxval=$val;
	$newindex=0;
	$len=count($A);
	if(empty( $A )) exit();
   
    for ($i=1;$i<$len;$i++) {
		if($bool){$j=$i; $bool=false;} //to keep the first index in A
		
		//check if the last value  < value in A 
		if($lastval<=$A[$i]){
			 $lastval=$A[$i];
			 $count++;
			}
		else {
		$resultintarray[$j]=$count;
		$lastval=$A[$i];
		$count=1;
		$bool=true;
		}
		}
	
	//get the index which had the max count
	foreach ($resultintarray as $key => $val) {
			//echo ($key-1).';'.$val.'<br/>';
			if($val>=$maxval){
			$newindex=($key-1);
			$maxval=$val;
			}
			}
return $newindex;
}



















/*for ($i = 1; $i <= 100; $i++)
{
    if (!($i % 15))
        echo "FizzBuzz<br/>";
    else if (!($i % 3))
        echo "Fizz<br/>";
    else if (!($i % 5))
        echo "Buzz<br/>";
    else
        echo "$i<br/>";
}*/
?>