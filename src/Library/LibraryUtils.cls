Class Library.LibraryUtils Extends %RegisteredObject
{

ClassMethod AddBook() As %Status
{
    set tSC = $$$OK
	// Create an object in which to store the book
	set book = ##class(Library.Book).%New()

    // Get the Book's Title
    read #!!,"Please enter the book title: ",name
    set book.Title = name

    // Get the Book's Author
    read !, "Please enetr the author of the book: ",author
    // Check if the author exists already
    &sql(SELECT id INTO :id FROM library.person WHERE name = :author)
    if (id '= "") {
        set book.Author = ##class(Library.Person).%OpenId(id)
    }
    else {
        // If not, create the object's Author
        set newAuthor = ##class(Library.Person).%New()
        set newAuthor.Name = author
        set book.Author = newAuthor
        set statusPerson = newAuthor.%Save()
    }

    // GEt the Gene
    read !, "Please Enter a 1 for Non-fiction or 2 for Fiction: ",genre
    if (genre = "1"){
        set book.Genre = "NonFiction"
    }
    else{
        set book.Genre = "Fiction"
    }

    set tSC = book.%Save()

    return tSC
}

ClassMethod AddFriend() As %Status
{
    set friend = ##class(Library.Person).%New()
    // Get and Store the name
    read #!!, "Please enter the Name of your friend: ",name
    set friend.Name = name

    // Get and Store the phone number
    read #!!, "Please enter the phone number of your friend: ",phoneNum
    set friend.PhoneNumber = phoneNum

    // Save the object and return the status
    set status = friend.%Save()
    return status
}

// This Method prints out one item in the database

ClassMethod PrintOne(ID As %String) As %Status
{
    // Open the book based on the ID given
    set book = ##class(Library.Book).%OpenId(ID)

    // write information about the book using the open object
    write !, "This book is called ", book.Title," and was written by ", book.Author.Name,"."
    write !, "This is a ",book.Genre," book."

    // Check if the book is on loan or not and return that to the user
    if book.Friend = ""{
        write !, "This book is currently in the Library,"
    }
    else{
        write !, "This book is currently on Loan to ",book.Friend.Name,"."
    }

    // Return a simple status of $$$OK
    return $$$OK
}

// This method prints all items from the database

ClassMethod PrintAll() As %Status
{
    &sql(select count(*) INTO :count from library.book)
    //Iterate through all books
    set id = 1
    WHILE (id <= count) {
        // This write will create a separator and give the user a correlation between book and ID
        write !, "BOOk at ID ",id, ": "
        do ##class(Library.LibraryUtils).PrintOne()
        set id = id + 1
    }

    return $$$OK
}

// This Method, LoanBook, loans a book to a friend

ClassMethod LoanBook(bookID As %String, friend As %String) As %Status
{
        // Open the book Object
    set check = ##class(Library.Book).%OpenId(bookID)
    // If not empty, tell the user it is currently on loan and point them to ReturnBook.  Quit.
    if (check.Friend '="")
    {
        write !, "This book is currently on Loan.",!,"Please use the ReturnBook method to return the book befor loaning it to a new friend."
        quit $$$OK
    }
    else
    {
        &sql(select id into :id From library.person where name = :friend)
        if (id = "")
        {
            write !, "This friend is not registered,",!,"Please use the Addfriend method to add a new friend."
            quit $$$OK
        }
        else{
            set friend = ##class(Library.Person).%OpenId(id)
            set check.Friend = friend
            write !, "Book loaned to ",friend.Name,"."
            set status = check.%Save()
        }
    }
    return $$$OK
}

// This Method, ReturnBook, returns a book from a loan to the library

ClassMethod ReturnBook(id As %String) As %Status
{
    &sql(SELECT friend into :friendID FROM library.book WHERE id = :id)
    set friend = ##class(Library.Person).%OpenId(friendID)
    set book = ##class(Library.Book).%OpenId(id)

    if (friend'="")
    {
        write !, "This book is not loaned.",!,"Please use the LoanBook() Method to loan it to a friend."
        quit $$$OK
    }
    else{
        write !, "Book returned by ",friend.Name, "."
        set book.Friend = ""
        set status = book.%Save()
        set status = friend.%Save()
    }
    return $$$OK
}

// This Method, GetLoanedBooks, will tell you how many books are out on loan

ClassMethod GetLoanedBooks() As %Status
{
    &sql(SELECt count(id) INTO :count FROM library.book WHERE friend IS NOT NULL)
    write !, count, "books are currently on loan,"
}

// This Method, GetShelfBooks, will return how many books are currently on the shelf, not loaned to friends.

ClassMethod GetShelfBooks() As %Status
{
    &sql(SELECT count(id) INTO :count FROm library.book WHERE friend IS NULL)
    write !, count, "book are currently on the shelves."
}

// This Method, FriendOwe, tells you how many books a friend has borrowed

ClassMethod FriendOwe(friend As %String) As %Status
{
    &sql(SELECt id INTO :id FROM library.person WHERE name = :friend)
    &sql(SELECT count(*) INTO :count FROM library.book WHERE friend = :id)
    write !, friend, "currently has", count, "book on loan."
}

/// / This Method, GetFriend, will return which friend a book is currently on loan to.
ClassMethod GetFriend(id As %String) As %Status
{
    set book = ##class(Library.Book).%OpenId(id)
    set friend = book.Friend.Name
    if (friend = "")
    {
        set friend = "no one"
    }
    write !, "This book currently loaned to ", friend,"."
}

}
