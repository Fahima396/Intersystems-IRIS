Class CustomFunctions.FormatUSPhone Extends Ens.Rule.FunctionSet
{

/// Description
ClassMethod FormatUSPhone(value As %String)
{

        //Remove non-numeric characters
        set phonenumber=$ZSTRIP(value, "*P")

        //If Phone length different than 10, leave it as is
        if $length(phonenumber)'=10{
            set phonestring = value
        }

    

    //Change the phone to the standard format (XXX)XXX-XXXX
    else{
        set phonestring = "("_$e(phonenumber,1,3)_")"_$e(phonenumber,4,6)_"-"_$e(phonenumber,7,10)
    }
    quit phonestring
}

}
