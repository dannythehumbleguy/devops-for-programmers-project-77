using static System.Reflection.Metadata.BlobBuilder;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace BookAPI.Models;

public class Author
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [JsonIgnore]
    public int AuthorID { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    [JsonIgnore]
    public List<Book> Books { get; set; }
    //This is the second part of the FK relationship
}
