# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.destroy_all

fake_users = [
  { email: 'chen61@mcmaster.ca', password: '123456' },
  { email: 'user2@example.com', password: 'password2' },
  { email: 'user3@example.com', password: 'password3' },
  { email: 'user4@example.com', password: 'password4' },
  { email: 'user5@example.com', password: 'password5' },
  { email: 'user6@example.com', password: 'password6' },
  { email: 'user7@example.com', password: 'password7' },
  { email: 'user8@example.com', password: 'password8' },
  { email: 'user9@example.com', password: 'password9' },
  { email: 'user10@example.com', password: 'password10' },
  { email: 'user11@example.com', password: 'password11' },
  { email: 'user12@example.com', password: 'password12' },
  { email: 'user13@example.com', password: 'password13' },
  { email: 'user14@example.com', password: 'password14' },
  { email: 'user15@example.com', password: 'password15' },
  { email: 'user16@example.com', password: 'password16' },
  { email: 'user17@example.com', password: 'password17' },
  { email: 'user18@example.com', password: 'password18' },
  { email: 'user19@example.com', password: 'password19' },
  { email: 'user20@example.com', password: 'password20' }
]

fake_posts = [
  { title: 'Lost and Found', content: 'I found a set of keys near the library. If they are yours, please contact me.' },
  { title: 'Study Group for Math 101', content: 'Looking for people to form a study group for Math 101. Let me know if interested!' },
  { title: 'Campus WiFi Issues', content: 'Is anyone else experiencing slow WiFi on campus? It’s been really frustrating lately.' },
  { title: 'Selling Used Textbooks', content: 'I’m selling my used textbooks for Biology 201 and Chemistry 101. DM me for details.' },
  { title: 'Looking for a Roommate', content: 'I’m looking for a roommate for the next semester. Preferably someone who is tidy and quiet.' },
  { title: 'Free Pizza at Student Center', content: 'There’s free pizza at the student center for the next hour. Come grab a slice!' },
  { title: 'Lost Wallet', content: 'I lost my wallet near the cafeteria. If anyone finds it, please let me know.' },
  { title: 'Club Recruitment Fair', content: 'Don’t forget to check out the club recruitment fair this Friday at the main hall!' },
  { title: 'Part-Time Job Opportunity', content: 'There’s a part-time job opening at the campus bookstore. Apply if interested.' },
  { title: 'Movie Night on Campus', content: 'Join us for a movie night this Saturday at the auditorium. Free popcorn included!' },
  { title: 'Need Help with Programming Assignment', content: 'I’m struggling with the programming assignment for CS101. Can anyone help?' },
  { title: 'Campus Gym Hours', content: 'Does anyone know the updated hours for the campus gym? I couldn’t find it online.' },
  { title: 'Carpool to Downtown', content: 'Looking for people to carpool to downtown this weekend. Let me know if interested.' },
  { title: 'Photography Club Meeting', content: 'The photography club is meeting this Thursday at 6 PM in Room 203. All are welcome!' },
  { title: 'Lost Earbuds', content: 'I lost my wireless earbuds near the library. If anyone finds them, please contact me.' },
  { title: 'Volunteers Needed for Event', content: 'We need volunteers for the upcoming charity event. Sign up if you’re interested!' },
  { title: 'Best Coffee on Campus?', content: 'What’s the best place to get coffee on campus? Looking for recommendations.' },
  { title: 'Roommate Wanted', content: 'Looking for a roommate to share a two-bedroom apartment near campus. DM for details.' },
  { title: 'Free Tutoring Sessions', content: 'Free tutoring sessions for Math and Physics are available at the learning center.' },
  { title: 'Campus Safety Tips', content: 'Remember to always lock your doors and keep your belongings safe. Stay alert!' }
]

fake_users.each do |user_data|
    user = User.find_or_create_by!(email: user_data[:email]) do |u|
      u.password = user_data[:password]
    end
  
    fake_posts.each do |i|
      post = Post.find_or_create_by!(title: i[:title], user_id: user.id) do |p|
        p.content = i[:content]
      end

      2.times do |j|
        Comment.find_or_create_by!(content: "Comment #{j + 1} by #{user.email}", post_id: post.id, user_id: user.id) do |c|
          c.content = "This is the content of comment #{j + 1} by #{user.email}."
        end
      end
    end
  end