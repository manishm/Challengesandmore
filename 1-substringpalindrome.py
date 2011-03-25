#Starting with the first we try to expand our palindrome till we find the mismatch or boundary
def LongestPalindrome(inputtext):
    length=len(inputtext)
    longestpalindrome=""
    i=0
    j=0
    k=0
    l=0
    lower=0
    higher=0
    while i<length and j<length:
        k=i
        l=j
        while k>0 and l<length and inputtext[k]==inputtext[l]:
            if higher-lower <= l-k:
                lower=k
                higher=l
            k=k-1
            l=l+1
        i=i+1
        j=j+1
 
        palindrome=inputtext[lower:higher+1]
        
        #update the longest palindrome if necessary
        if len(palindrome)>len(longestpalindrome):
            longestpalindrome=palindrome
    return longestpalindrome

print LongestPalindrome('FourscoreandsevenyearsagoourfaathersbroughtforthonthiscontainentanewnationconceivedinzLibertyanddedicatedtothepropositionthatallmenarecreatedequalNowweareengagedinagreahtcivilwartestingwhetherthatnaptionoranynartionsoconceivedandsodedicatedcanlonghigherureWeareqmetonagreatbattlefiemldoftzhatwarWehavecometodedicpateaportionofthatfieldasafinalrestingplaceforthosewhoheregavetheirlivesthatthatnationmightliveItisaltogetherfangandproperthatweshoulddothisButinalargersensewecannotdedicatewecannotconsecratewecannothallowthisgroundThebravelmenlivinganddeadwhostruggledherehaveconsecrateditfaraboveourpoorponwertoaddordetractTgheworldadswfilllittlenotlenorlongrememberwhatwesayherebutitcanneverforgetwhattheydidhereItisforusthelivingrathertobededicatedheretotheulnfinishedworkwhichtheywhofoughtherehavethusfarsonoblyadvancedItisratherforustobeherededicatedtothegreattdafskremainingbeforeusthatfromthesehonoreddeadwetakeincreaseddevotiontothatcauseforwhichtheygavethelastpfullmeasureofdevotionthatweherehighlyresolvethatthesedeadshallnothavediedinvainthatthisnationunsderGodshallhaveanewbirthoffreedomandthatgovernmentofthepeoplebythepeopleforthepeopleshallnotperishfromtheearth')
