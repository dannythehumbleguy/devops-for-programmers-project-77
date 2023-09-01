using Microsoft.EntityFrameworkCore;

namespace BookAPI.Models;

public class MyDbContext : DbContext
{
    public MyDbContext(DbContextOptions<MyDbContext> options): base(options)
    {
        Database.Migrate();
    }
    
    public DbSet<Book> Books { get; set; }
    public DbSet<Author> Authors { get; set; }
}
