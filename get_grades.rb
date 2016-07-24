require 'mechanize'
require 'json'

def get_agent
  mechanize = Mechanize.new
  mechanize.history_added = Proc.new { sleep 3 }
  mechanize.follow_meta_refresh = true 
  mechanize.verify_mode = OpenSSL::SSL::VERIFY_NONE
  return mechanize
end

agent = get_agent()
cg_list = []
year = "14"
dept = "ME"
if ARGV[0] == "btech"
  type = {1=> 85}
  filename = "btech"
elsif ARGV[0] == "dd"
  type = {3=> 55}
  filename = "dd"
else
  type = {1=> 85,3=> 55}
  filename = "all"
end
type.each do |k,v|
  for i in (1..v)
    begin
      type = k.to_s
      number = i > 9 ? i.to_s : "0"+i.to_s
      rollno = year+dept+type+"00"+number
      url = "https://erp.iitkgp.ernet.in/StudentPerformance/view_performance.jsp?rollno=#{rollno}"
      page = agent.get(url)
      cgpa = page.search("table")[1].search("tr")[1].children.last.text.split("CGPA")[1][0..3].to_f
      name = page.search("fieldset")[0].search("table")[0].search("tr")[1].search("td")[3].text
      cg = { "RollNumber" => rollno, "Name" => name, "CGPA" => cgpa }
      puts "#{rollno} - #{name} - #{cgpa}"
      cg_list.push(cg)  
    rescue
    end
  end
end

File.open("grades_#{filename}.json", "a") { |file| file.write(JSON.pretty_generate(cg_list)) }