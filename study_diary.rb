require 'sqlite3'

class StudyApp
  def initialize
    loop do
      print_menu
      option = gets.chomp.to_i
      if option == 1
        create_item
      elsif option == 2
        list_items
      elsif option == 3
        search_items
      elsif option == 4
        search_category
      elsif option == 5
        add_category
      elsif option == 6
        puts "Obrigado!"
        break
      else
        puts "Opção inválida! Tente novamente."
      end
    end
  end

  def print_menu
    puts "[1] Cadastrar um item para estudar"
    puts "[2] Ver todos os itens cadastrados"
    puts "[3] Buscar um item de estudo"
    puts "[4] Buscar um item pela categoria"
    puts "[5] Adicionar uma categoria"
    puts "[6] Sair"
    print "Escolha uma opção: "
  end

  def create_item
    print "Digite o título do item: "
    title = gets.chomp

    db = SQLite3::Database.new("./mydatabase.db")
    db.execute("PRAGMA foreign_keys = ON")
    categories = db.execute("SELECT * FROM CATEGORY")
    db.close

    print_categories(categories)

    print "Escolha a categoria: "
    category_item = gets.chomp.to_i

    db = SQLite3::Database.open("./mydatabase.db")
    db.execute("INSERT INTO TB_DIARY_STUDY (ID_CATEGORY, ITEM) VALUES (?, ?)", [category_item, title])
    db.close

    puts "Item criado com sucesso!"
  end

  def add_category
    print "Digite uma categoria: "
    title_category = gets.chomp.to_s

    db = SQLite3::Database.new("./mydatabase.db")
    db.execute("INSERT INTO CATEGORY (NAME) VALUES (?)", [title_category])
    db.close

    puts "Categoria criada com sucesso: #{title_category}"
  end

  def list_items
    db = SQLite3::Database.new("./mydatabase.db")
    items = db.execute("SELECT  TB_DIARY_STUDY.ITEM,
      CATEGORY.NAME
      FROM 	TB_DIARY_STUDY
  inner join CATEGORY ON (TB_DIARY_STUDY.ID_CATEGORY = CATEGORY.ID) ")
    db.close

    if items.empty?
      puts "Não há itens cadastrados!"
    else
      items.each do |item|
        puts "#{item[0]} - #{item[1]}"
      end
    end
  end

  def search_items
    print "Digite uma palavra-chave para buscar: "
    key = gets.chomp

    db = SQLite3::Database.new("./mydatabase.db")
    items = db.execute("SELECT  TB_DIARY_STUDY.ITEM,
      CATEGORY.NAME
      FROM 	TB_DIARY_STUDY
  inner join CATEGORY ON (TB_DIARY_STUDY.ID_CATEGORY = CATEGORY.ID)
  WHERE ITEM LIKE ?", ["%#{key}%"])
    db.close

    if items.empty?
      puts "Não foram encontrados itens com a palavra-chave '#{key}'"
    else
      puts "Itens encontrados:"
      items.each do |item|
        puts "#{item[1]} - #{item[0]}"
      end
    end
  end

  def search_category
    db = SQLite3::Database.new("./mydatabase.db")
    db.execute("PRAGMA foreign_keys = ON")
    categories = db.execute("SELECT * FROM CATEGORY")
    db.close

    print_categories(categories)
    
    print "Escolha uma categoria para a busca: "
    category_item = gets.chomp.to_i

    db = SQLite3::Database.new("./mydatabase.db")
    items = db.execute("SELECT  TB_DIARY_STUDY.ITEM,
      CATEGORY.NAME
      FROM 	TB_DIARY_STUDY
  inner join CATEGORY ON (TB_DIARY_STUDY.ID_CATEGORY = CATEGORY.ID) 
  WHERE ID_CATEGORY = ?", [category_item])
    db.close

    if items.empty?
      puts "Não foram encontrados itens com a categoria selecionada."
    else
      puts "Itens encontrados:"
      items.each do |item|
        puts "#{item[1]} - #{item[0]}"
      end
    end
  end

  def print_categories(categories)
    categories.each_with_index do |category, index|
      puts "#{index + 1}. #{category[1]}"
    end
  end
end

app = StudyApp.new