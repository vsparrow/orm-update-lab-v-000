require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name,:grade
  attr_reader :id
  def initialize(name,grade,id=nil)
    @name=name
    @grade=grade
    @id=id
  end #initialze

#*********************************************************************************************HERE!!!!!!!
  def update
    # You can't update multiple tables in one statement,
    sql = "UPDATE students SET name = (?) WHERE id = (?)"
    updated=DB[:conn].execute(sql,@name,@id)
    sql = "UPDATE students SET grade = (?) WHERE id = (?)"
    updated=DB[:conn].execute(sql,@grade,@id)

  end

  def save
    #save saves an instance of the Student class to the database and then sets the given students `id` attribute
    if @id != nil
      #update
      self.update
    else
      sql = "INSERT INTO students(name,grade) VALUES (?,?)"
      DB[:conn].execute(sql,@name,@grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end #if
  end #save
  #************************************************************************SELF
  #************************************************************************
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end #create_table

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end #drop_table

  def self.create(name,grade)
    s = Student.new(name,grade)
    s.save
  end #create

  def self.new_from_db(row)
    # puts "****#{row}"
    s=Student.new(row[1],row[2],row[0])
  end


  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    row = DB[:conn].execute(sql,name)
    # puts "*****#{row}"
    s=Student.new(row[0][1],row[0][2],row[0][0])
  end #find_by_name
end #Student
