using BookAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<MyDbContext>(
    options => options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));
var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapGet("/books", async (MyDbContext context) => await context.Books.ToListAsync());

app.MapPost("/books", async (MyDbContext context, Book book) =>
{
    try { 
        await context.Books.AddAsync(book);
        await context.SaveChangesAsync();
        return Results.Created($"Created book with id {book.BookID}", book);
    }
    catch(Exception e)
    {
        return Results.Problem(detail: e.Message);
    }
    
});

app.MapPost("/authors", async (MyDbContext context, Author author) =>
{
    try { 
        await context.Authors.AddAsync(author);
        await context.SaveChangesAsync();
        return Results.Created($"Created author with id {author.AuthorID}", author);
    }
    catch(Exception e)
    {
        return Results.Problem(detail: e.Message);
    }
});

app.MapGet("/authors", async (MyDbContext context) => await context.Authors.ToListAsync());

app.MapPost("/seed", async (MyDbContext context) =>
{
    await context.Authors.AddAsync(new Author
    {
        Name = "John Stuart Mill",
        Description = "A british philosopher and author"
    });
    await context.SaveChangesAsync();
    var mill = await context.Authors.FirstOrDefaultAsync();
    await context.Books.AddAsync(new Book
    {
        Title = "The wealth of nations",
        NumberOfTimesViewed = 10,
        AuthorID = mill.AuthorID
    });
    await context.SaveChangesAsync();
    return Results.Ok();
});

app.Run();
