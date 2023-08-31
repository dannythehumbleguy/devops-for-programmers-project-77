using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace BookAPI.Models;

public class Book
{
    //These properties are called Data Annotations, the "Key" property
    //Defines a primary key in the db
    //This annotations communicates that this is an auto generated column, it will
    //create a new value automatically when a new book is inserted
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [JsonIgnore]
    public int BookID { get; set; }
    public string Title { get; set; }
    public int NumberOfTimesViewed { get; set; }
    public int AuthorID { get; set; }
    [JsonIgnore]
    public Author Author { get; set; }
    //This creates a foreign key relationship, the AuthorID property
    //makes us able to insert books and link them to authors easily
    //You dont actually need to add the last two lines
    //The list in the Author is enough

}

