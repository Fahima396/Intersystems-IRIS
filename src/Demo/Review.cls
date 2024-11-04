Class Demo.Review Extends %Persistent
{

/// Description
ClassMethod StoreJSON(JSONString) As %String [ ZenMethod ]
{
        set responseObject = {"message":"start message"}
        try{
            //1. Create dynamic object for json %String
            set dynamicObject = ##class(%DynamicAbstractObject).%FromJSON(JSONString)

            //2. Modify the contents by adding a timestamp and setting source
            do dynamicObject.%Set("timestamp",$ZDATETIME($h,3))
            set dynamicObject.source = "website"

            //3. Get review number based on size
            &sql(select count(*) into :size from Restaurant.Reviews)
            do dynamicObject.%Set("reviewnumber", size+1)

            //4. Save in the database
            set reviewPersist = ##class(Restaurant.Reviews).%New()
            set reviewPersist.rating = dynamicObject.rating
            set reviewPersist.review = dynamicObject.review
            set reviewPersist.reviewer = dynamicObject.reviewer
            set reviewPersist.source = dynamicObject.source
            set reviewPersist.timestamp = dynamicObject.timestamp
            set status = reviewPersist.%Save()

            //5. Create feedback text based on ratings
            if ((dynamicObject.rating = "Excellent") || (dynamicObject.rating = "Good") || (dynamicObject.rating = "Average"))
            {
                //Create dynamic object string using %New and %set
                set responseObject = ##class(%DynamicObject).%New()
                do responseObject.%Set("message","Thanks for your great review")
            }
            else{
                //Alternate quickhand way to create dynamic object
                set responseObject = {"measage":"Thanks for your review. Please come again so we can make it upto you."}
            }
        }   
        catch(ex){
            set responseObject = {}
            do responseObject.%Set("message","JSON message: *"_JSONString_"* is invalid")
        }
        quit responseObject.%ToJSON()
}

Storage Default
{
<Data name="ReviewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Demo.ReviewD</DataLocation>
<DefaultData>ReviewDefaultData</DefaultData>
<IdLocation>^Demo.ReviewD</IdLocation>
<IndexLocation>^Demo.ReviewI</IndexLocation>
<StreamLocation>^Demo.ReviewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
