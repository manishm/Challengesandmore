def powerset(slist): 
    length = len(slist)
    result=[]
    #As powerset will contain 2^length elements hence the range
    for i in range(2**length): 
        currenti = i 
        subset = [] 
        for j in range(length): 
            if currenti & 1: 
                subset.append(slist[j]) 
            currenti >>= 1 
        result.append(subset) 
    return result
    
if __name__ == "__main__":
    setlist=powerset([1,2,3,4,6])
    for item in setlist:
        #To get all the lists for which the length>2
        if len(item)>2:
            maxitem=max(item)
            newitem=item.remove(maxitem)
            sumitem=sum(item)
            if(sumitem==maxitem):
                print item,maxitem
        
