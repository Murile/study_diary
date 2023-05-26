require_relative 'category'
require_relative 'study_item'
require 'sqlite3'

class StudyApp
  def initialize
    @items = []
    @categories = [
      Category.new("Ruby", @items),
      Category.new("JavaScript", @items),
      Category.new("Html", @items)
    ]
  end

  def run
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
    title = gets.chomp.downcase()

    print_categories
    print "Escolha a categoria:"
    category_item = gets.chomp.to_i - 1
    db = SQLite3::Database.open "db/database.db"
    db.execute "INSERT INTO TB_DIARY_STUDY VALUES('#{ title }', '#{ category_item }')"
    db.close

    puts "Item criado com sucesso: #{item.title} (#{item.category.name})"
  end

  def add_category
    print "Digite uma categoria:"
    title_category = gets.chomp.to_s
    db = SQLite3::Database.open "db/database.db"
    db.execute "INSERT INTO CATEGORY VALUES('#{ title_category }')"
    db.close


    puts "Categoria criado com sucesso: #{category.name}"
  end

  def list_items
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    tasks = db.execute "SELECT * FROM TB_DIARY_STUDY"
    db.close
   
    end
  end

  def search_items
    print "Digite uma palavra-chave para buscar: "
    key = gets.chomp.downcase()
    
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    tasks = db.execute "SELECT * FROM TB_DIARY_STUDY where ITEM like '#{key}'"
    db.close
   

    if search_items.empty?
      puts "Não foram encontrados itens com a palavra-chave '#{key}'"
    else
      puts "Itens encontrados:"
      search_items.each do |item|
        puts "#{item.title} #{item.category.name}"
      end
    end
  end

  def search_category
    
    print_categories
    print "Escolha uma categoria para a busca: "
    category_item = gets.chomp.to_i - 1
    
   itens = @categories[category_item].itens 

    if itens.nil?
      puts "Não foram encontrados itens com a palavra-chave"
    else
      puts "Itens encontrados:"
      itens.each do |item|
        puts "#{item.category.name} - #{item.title}"
      end
    end
  end

  def print_categories
    @categories.each_with_index do |category, index|
      puts "#{index + 1}. #{category.name}"
    end
  end

end

app = StudyApp.new
app.run