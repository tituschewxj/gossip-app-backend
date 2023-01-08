# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require_relative '../lib/populator_fix.rb'

# to reset the database: delete the developemnt.sqlite3 file and run rails db:setup

10.times do
    # create users
    password = 'password'
    username = Faker::Twitter.unique.screen_name
    email = username + '@email.com'
    description = Faker::Quote.famous_last_words
    user = User.create(email: email, password: password)
    profile = Profile.create(user_id: user.id, username: username, description: description)

    # create posts
    rand(3..10).times do
        title = Faker::Lorem.sentence
        content = Faker::Lorem.paragraphs(number: rand(1..6)).join("\n\n")
        author = username
        date = Faker::Date.between(from: 1.year.ago, to: Date.today)
        post = Post.create(title: , content: content, author: username, profile_id: profile.id, updated_at: date, created_at: date)
    end
end


Post.all.each do |post|
    # create comments
    rand(3..10).times do
        content = Faker::Lorem.paragraph(sentence_count: rand(1..3))
        profile = Profile.find(rand(1..Profile.all.count))
        date = Faker::Date.between(from: post.created_at, to: Date.today)
        comment = Comment.create(content: content, author: profile.username, profile_id: profile.id, post_id: post.id, updated_at: date, created_at: date)
    end
end


20.times do
    # create tags
    name = Faker::Verb.unique.base
    tag = Tag.create(name: name)
    
end

Post.all.each do |post|
    # add tags
    rand(0..3).times do
        post = Post.find(rand(1..Post.all.count))
        tag = Tag.find(rand(1..Tag.all.count))
        if PostsTag.find_by(post_id: post.id, tag_id: tag.id) === nil
            posts_tags = PostsTag.create(post_id: post.id, tag_id: tag.id)
        end 
    end
end