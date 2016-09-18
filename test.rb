require 'unirest'
require 'json'

puts 'hello world'

begin
	puts "acquire process id"
	response = Unirest.post "https://api.cloudconvert.com/process", 
                        headers:{:Authorization => "Bearer LahV9x0_cmH7g8DJcfwCNXn8WDxETgkiCkkMJabLDFj6T4-LWjtecclYMEDOIVdO6ySN957l6ZNJu43x_Bb7Ow" }, 
                        parameters:{:inputformat => "m4a", :outputformat => "wav"}

	puts response.code

	body = response.body

	puts response.body.to_json

	process_id_url = "https:" + body["url"]

	puts "upload setup"
	response = Unirest.post process_id_url,
						headers:{:input => "upload", :save => true},
						parameters:{:input => "upload"}

	puts response.code

	body = response.body

	puts response.body

	upload_url = "https:" + body["upload"]["url"] + "/file1.m4a"

	puts "upload + #{upload_url}"

	response = Unirest.put upload_url,
							parameters:{:file => File.new("file1.m4a", 'rb')}

	puts response.code

	puts "======================================================================================"

	loop do
		puts "status"
		sleep(3)

		puts "before call"

		response = Unirest.get process_id_url

		puts "after call"
		puts response.code
		if(200 <= response.code || response < 300)
			puts response.body["step"]
		end
		break if response.body["step"] == "finished"
	end

	converted_audio_file = File.new("file1.wav", "w") {|f| f.write(response.body)}

rescue
	puts "failure"
	puts response.body
end

