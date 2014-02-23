module LevelImportService
  def self.populate
    level_filenames = []
    Dir.foreach('public/data/Levels') do |filename|
      next if filename == '.' or filename == '..'
      filename[0] = '' # remove first 'l'
      level_filenames << filename
    end

    # loop on each level
    level_filenames.sort_by { |a| a.to_i }.each do |filename|
      filename = "l#{filename}" # place first 'l'
      puts "Import level : #{filename}"

      # Open pack file
      File.open("public/data/Levels/#{filename}", 'r') do |f|
        xml_doc = Nokogiri::XML(f)

        level = Level.create!({ :file_name        => filename,
                                :name             => xml_doc.css('level > info > name').text().strip,
                                :description      => xml_doc.css('level > info > desription').text().strip,
                                :author           => xml_doc.css('level > info > author').text().strip,
                                :date             => xml_doc.css('level > info > date').text().strip,
                                :level_identifier => xml_doc.css('level').first['id'].try(:strip),
                                :level_pack       => xml_doc.css('level').first['levelpack'].try(:strip),
                                :level_pack_num   => xml_doc.css('level').first['levelpackNum'].try(:strip),
                                :rversion         => xml_doc.css('level').first['rversion'].try(:strip) })
      end
    end
  end
end

