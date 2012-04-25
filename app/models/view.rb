class View < ActiveRecord::Base
    has_many :domains

    validates_presence_of :name

    def zones_dir
        self.name + '-' + GloboDns::Config::ZONES_DIR
    end
    def zones_file
        self.name + '-' + GloboDns::Config::ZONES_FILE
    end

    def slaves_dir
        self.name + '-' + GloboDns::Config::SLAVES_DIR
    end
    def slaves_file
        self.name + '-' + GloboDns::Config::SLAVES_FILE
    end

    def reverse_dir
        self.name + '-' + GloboDns::Config::REVERSE_DIR
    end
    def reverse_file
        self.name + '-' + GloboDns::Config::REVERSE_FILE
    end

    def to_bind9_conf(indent = '')
        str  = "#{indent}view \"#{self.name}\" {\n"
        str << "#{indent}    match-clients      { #{self.clients}; };\n"      if self.clients.present?
        str << "#{indent}    match-destinations { #{self.destinations}; };\n" if self.destinations.present?
        str << "\n"
        str << "#{indent}    include \"#{File.join(GloboDns::Config::BIND_CONFIG_DIR, self.zones_file)}\";\n"
        str << "#{indent}    include \"#{File.join(GloboDns::Config::BIND_CONFIG_DIR, self.slaves_file)}\";\n"
        str << "#{indent}    include \"#{File.join(GloboDns::Config::BIND_CONFIG_DIR, self.reverse_file)}\";\n"
        str << "#{indent}};\n\n"
        str
    end
end