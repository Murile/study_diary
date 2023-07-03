require 'sqlite3'
require_relative './programa/category'
require_relative './programa/study_item'

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

    result = Category.all

    print_categories(result)
    
    print "Escolha a categoria: "
    category_item = gets.chomp.to_i

    db = SQLite3::Database.open("./mydatabase.db")
    db.execute("INSERT INTO TB_DIARY_STUDY (ID_CATEGORY, ITEM, ACCESS_COUNT) VALUES (?, ?, 0)", [category_item, title])
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
    items = StudyItem.all
  
    if items.empty?
      puts "Não há itens cadastrados!"
    else
      items.each do |item|
        puts "#{item[0]} - #{item[1]}"
      end
    end
  end

  def search_items
    print_suggested_items

    print "Digite uma palavra-chave para buscar: "
    key = gets.chomp

    items = StudyItem.find_itens(key)

    if items.empty?
      puts "Não foram encontrados itens com a palavra-chave '#{key}'"
    else
      puts "Item encontrado:"
      items.each do |item|
        puts "#{item[1]} - #{item[2]} - Qtd. de acessos: #{item[3]}"
        StudyItem.increment_access_count(item[0])
      end
    end
  end

  def search_category

    full = Category.all
    print_categories_with_access_count(full)
    
    print "Escolha uma categoria para a busca: "
    category_item = gets.chomp.to_i

    result = Category.find_by(category_item)

    if result.empty?
      puts "Não foram encontrados itens com a categoria selecionada."
    else
      puts "Itens encontrados:"
      result.each do |item|
        puts "#{item[1]} - #{item[0]}"
      end
    end
  end

  def print_suggested_items
    db = SQLite3::Database.new("./mydatabase.db")
    suggested_items = db.execute("SELECT TB_DIARY_STUDY.ID,
      TB_DIARY_STUDY.ITEM,
      CATEGORY.NAME,
      TB_DIARY_STUDY.ACCESS_COUNT
      FROM TB_DIARY_STUDY
      INNER JOIN CATEGORY ON (TB_DIARY_STUDY.ID_CATEGORY = CATEGORY.ID)
      WHERE TB_DIARY_STUDY.ACCESS_COUNT > 0
      ORDER BY TB_DIARY_STUDY.ACCESS_COUNT DESC
      LIMIT 3")
    db.close

    if suggested_items.empty?
      puts "Não há itens sugeridos no momento."
    else
      puts "Sugestões de itens mais acessados:"
      suggested_items.each do |item|
        puts "#{item[1]} - #{item[2]} - Qtd.acessos: #{item[3]}"
      end
    end
  end

  def print_categories_with_access_count(categories)
    categories.each do |category|
      count = Category.total_access_count(category[0])
      puts "#{category[1]} (Total de Acessos: #{count})"
    end
  end

  def print_categories(categories)
    categories.each_with_index do |category, index|
      puts "#{index + 1}. #{category[1]}"
    end
  end

end

app = StudyApp.new