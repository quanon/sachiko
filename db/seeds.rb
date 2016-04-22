# XML ファイルは
# https://dumps.wikimedia.org/jawiki/latest/jawiki-latest-abstract.xml
# をダウンロードする。
xml_file = File.open(ENV['WIKIPEDIA_XML_FILEPATH'])

class DocReader
  KEYS = [:title, :abstract, :url].freeze
  Doc = Struct.new(*KEYS)

  def initialize(xml_filepath)
    @xml_filepath = xml_filepath
  end

  def each
    return enum_for(:each) unless block_given?

    xml_reader.each do |node|
      next unless node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
      next unless node.name == 'doc'

      doc_node = Nokogiri::XML(node.outer_xml)
      doc = Doc.new(*KEYS.map { |key| doc_node.css(key).inner_text })
      doc.title = doc.title[%r{(?<=Wikipedia: ).*}]

      yield(doc)
    end
  end

  private

  def xml_reader
    @xml_reader ||= Nokogiri::XML::Reader(xml_file)
  end

  def xml_file
    @xml_file ||= File.open(@xml_filepath)
  end
end

ApplicationRecord.transaction do
  Article.delete_all

  DocReader.new(xml_file).each.with_index(1) do |doc, i|
    Article.create!(doc.to_h)

    puts(i)
  end
end
