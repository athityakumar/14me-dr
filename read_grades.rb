require 'json'
require 'csv'

def csv_write filename , *field
  
  CSV.open(filename, "a") do |csv|
    if field.count == 2
      csv << [field[0],field[1]]
    elsif field.count == 3 
      csv << [field[0],field[1],field[2]]
    elsif field.count == 4 
      csv << [field[0],field[1],field[2],field[3]]
    elsif field.count == 5 
      csv << [field[0],field[1],field[2],field[3],field[4]]
    elsif field.count == 6 
      csv << [field[0],field[1],field[2],field[3],field[4],field[5]]    
    end
  end
    
end

def print name_list , rollno_list , cg_list , rollno , filename

  index = rollno_list.find_index(rollno)
  dr = cg_list.uniq.count - cg_list.uniq.sort.find_index(cg_list[index])
  puts ""
  puts "Name : #{name_list[index]}"
  puts "Roll Number : #{rollno_list[index]}"
  puts "CGPA : #{cg_list[index]}"
  puts "Dept Rank : #{dr} / #{cg_list.count}"
  if filename != "none"
    csv_write("ranks_#{filename}.csv",rollno_list[index],name_list[index],cg_list[index],dr)
  end
end

def get_lists cg_hash_list
  name_list , cg_list , rollno_list = [] , [] , []
  cg_hash_list.each do |cg_hash|
    name_list.push(cg_hash["Name"])
    cg_list.push(cg_hash["CGPA"])
    rollno_list.push(cg_hash["RollNumber"])
  end
  return name_list , cg_list , rollno_list
end

if ARGV[0] == "many"
  if ARGV[1] == "btech"
    filename = "btech"
  elsif ARGV[1] == "dd"
    filename = "dd"  
  else
    filename = "all"
  end
  cg_hash_list = JSON.parse(File.read("grades_#{filename}.json"))
  name_list , cg_list , rollno_list = get_lists(cg_hash_list)
  csv_write("ranks_#{filename}.csv","Roll Number","Name","CGPA","Dept Rank")
  rollno_list.each do |rollno|
    print(name_list,rollno_list,cg_list,rollno,filename) 
  end
else
  puts "Enter your roll number"
  rollno = gets.chomp.upcase
  print(name_list,rollno_list,cg_list,rollno,"none")
end
