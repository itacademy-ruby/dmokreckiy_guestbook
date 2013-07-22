require 'sinatra'


get '/' do
  @message_board = read_posts_from_file
  erb :index
end

post '/' do
  @author = params[:author]
  @content = params[:content]
  @content.gsub!("\r\n", "<br />")
  post_to_file @author, @content
  redirect to '/'
end

def read_posts_from_file
  @board = ""
  @iterator = 0
  unless File.readlines('posts.txt').empty?
    File.readlines('posts.txt').each do |line|
      line.split(';').each do |element|
        case @iterator
          when 0
            @board << "Date: "
          when 1
            @board << "Author: "
          when 2
            @board << "Content: "
          when 3
            @board << "<hr> Date: "
        end
        
        @board << "#{element}<br />"
        
        if @iterator <= 2 
          @iterator += 1
        else
          @iterator = 1
        end

      end
    end
  end
  @board
end

def post_to_file author, content
  File.open('posts.txt', 'a') do |file|
    temp_time = Time.new
    file.print "#{temp_time.day}.#{temp_time.month}.#{temp_time.year} #{temp_time.hour}:#{temp_time.min};"
    file.print "#{author};"
    file.puts "#{content}\n"
  end
end
