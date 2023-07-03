class StudyItem

  attr_reader :title, :category

    def initialize(title, category)
      @title = title
      @category = category
    end

    def self.all
      db  =SQLite3::Database.new("./mydatabase.db")
      items = db.execute("SELECT  TB_DIARY_STUDY.ITEM,
      CATEGORY.NAME
      FROM 	TB_DIARY_STUDY
  
     inner join CATEGORY ON (TB_DIARY_STUDY.ID_CATEGORY = CATEGORY.ID)")
      db.close

      items
    end

    def self.find_by(id)
      print "Digite um id para a busca: "
      id = gets.chomp.to_i
  
      db = SQLite3::Database.new("./mydatabase.db")
      db.execute("PRAGMA foreign_keys = ON")
      item = db.execute("SELECT TB_DIARY_STUDY.ITEM, CATEGORY.NAME
                        FROM TB_DIARY_STUDY
                        INNER JOIN CATEGORY ON (TB_DIARY_STUDY.ID_CATEGORY = CATEGORY.ID)
                        WHERE TB_DIARY_STUDY.ID = ?", [id])
      db.close
      end

      def self.increment_access_count(item_id)
        db = SQLite3::Database.new("./mydatabase.db")
        acess = db.execute("UPDATE TB_DIARY_STUDY SET 
          ACCESS_COUNT = ACCESS_COUNT + 1 WHERE ID = ?", [item_id])
        db.close
      end

      def self.find_itens(key)
        db = SQLite3::Database.new("./mydatabase.db")
        items = db.execute("SELECT TB_DIARY_STUDY.ID, 
        TB_DIARY_STUDY.ITEM, 
        CATEGORY.NAME, 
        TB_DIARY_STUDY.ACCESS_COUNT
        FROM TB_DIARY_STUDY
        INNER JOIN CATEGORY ON (TB_DIARY_STUDY.ID_CATEGORY = CATEGORY.ID)
        WHERE ITEM LIKE ?", ["%#{key}%"])
        db.close 

        items
      end
end

