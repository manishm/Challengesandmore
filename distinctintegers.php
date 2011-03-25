<?PHP
$A = array(5, -3, -1, -10, -7, -6,100,1,-12);
echo absDistinct($A);

function absDistinct ( $A ) {
    $newintarray=array(); //store key-values

    foreach($A as $value){
        if(!array_key_exists(abs($value),$newintarray)){
            $newintarray[abs($value)]=true;
                }
    }
    
    return count($newintarray);
    
    
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