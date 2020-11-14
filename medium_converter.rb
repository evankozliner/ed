# Simple script for installing a post off of a medium, converting to markdown 
require 'uri'

# TODO lose
#`rm _texts/aws-iam-introduction-20c1f017c43.md`
#`rm _texts/a-free-coding-curriculum-for-beginners-5f16c948e7b4.md`

URL = ARGV[0]
FILENAME = URL.split("/")[-1]
DESTINATION_DIR = "_texts"
FULL_PATH = "#{DESTINATION_DIR}/#{FILENAME}.md"

def main
  `rm #{FULL_PATH}`
  
  puts "Creating file #{FILENAME} in #{DESTINATION_DIR} for URL #{URL}"
  
  `mediumexporter #{URL} --jekyll >> #{FULL_PATH}`
  title = get_title
  delete_top_2_lines
  write_top("---")
  write_top("author: Evan Kozliner")
  # Double escape for pesky colons
  write_top(%Q(title: \\"#{title}\\"))
  write_top("layout: narrative")
  write_top("---")
  replace_tweets
  replace_code_blocks

  if ARGV.size > 1
      replace_youtube_videos ARGV[1].split(",")
  end

end

def replace_tweets
  lines = []
  puts FULL_PATH
  # For each line
  File.open(FULL_PATH, "r").read.split("\n").each do |line|
    # Look for iframe with medium.com/media
    if (line.include? "iframe") && (line.include? "medium.com/media")
      tweet_html = scrape_tweet(line)

      if tweet_html
        lines << tweet_html
      else
        lines << line
      end
    else
      lines << line
    end
  end

  File.open(FULL_PATH, "w+") do |f|
    lines.each do |l|
      f.puts(l)
    end
  end
  
end

def scrape_tweet url_line
  puts "scraping #{URI.extract(url_line)[0]}"
  url = URI.extract(url_line)[0]

  followed_url = `curl -L #{url}`
  puts followed_url
  if (followed_url.include? "twitter.com") && (followed_url.include? "status")
    puts "found tweet"
    tweet_url = URI.extract(followed_url).filter {|item| item.include? "twitter.com"}[0]
    puts tweet_url.to_s

    return %Q(<blockquote class="twitter-tweet" data-conversation="none" data-align="center" data-dnt="true"><p>&#x200a;&mdash;&#x200a;<a href="#{tweet_url}">@neiltyson</a></p></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>)
  end

  return false
end

def replace_code_blocks
  lines = []
  puts FULL_PATH
  # For each line
  File.open(FULL_PATH, "r").read.split("\n").each do |line|
    # Look for iframe with medium.com/media
    if (line.include? "iframe") && (line.include? "medium.com/media")
      gist_md = `python gist2markdown/gist2markdown.py -u #{URI.extract(line)[0]}`
      lines << gist_md
    else
      lines << line
    end
  end

  File.open(FULL_PATH, "w+") do |f|
    lines.each do |l|
      f.puts(l)
    end
  end
end

def replace_youtube_videos videos
  #https://www.youtube.com/embed/
  lines = []
  puts FULL_PATH
  # For each line
  File.open(FULL_PATH, "r").read.split("\n").each do |line|
    # Look for iframe with medium.com/media
    if (line.include? "iframe") && (line.include? "youtube")
      youtube_vid = "https://www.youtube.com/embed/#{videos.shift}"
      youtube_md = %Q(<center><iframe width="560" height="315" src="#{youtube_vid}" frameborder="0" allowfullscreen></iframe></center>)
      puts youtube_md
      lines << youtube_md
    else
      lines << line
    end
  end

  File.open(FULL_PATH, "w+") do |f|
    lines.each do |l|
      f.puts(l)
    end
  end
end

def delete_top_2_lines
  # Top 2 lines have an empty line and an unnecessary file
  text=''
  File.open(FULL_PATH, "r"){ |f| f.gets; f.gets; text=f.read }
  File.open(FULL_PATH, "w+"){ |f| f.write(text) }
end

def write_top line
  `echo "#{line}\n$(cat #{FULL_PATH})" > #{FULL_PATH}`
end

def get_title 
  top_lines = `cat #{FULL_PATH} | head -n 2`

  # 2nd Line contains an unecessary title with an h1 (#) tag. This fetches the title.
  return top_lines.gsub("#", "")
end

main
