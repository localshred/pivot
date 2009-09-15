class Iteration
  attr_reader :id, :project_id, :number, :type, :start_date, :finish_date, :stories, :limit, :offset, :token
  
  def self.find(options={})
    @token = options[:token] || Token.new
    if options.include?(:project_id)
      @project_id = options[:project_id]
      api_url = "#{CONFIG[:api_location]}/projects/#{@project_id}/iterations/#{options.include?(:type) ? options[:type] : ""}"
      iterations = (Hpricot(open(api_url, {"X-TrackerToken" => @token.to_s}))/'iteration').map do |iteration|
        Iteration.new(:iteration => iteration, :project_id => @project_id)
      end
    end
  end
  
  def initialize(options={})
    @token = options[:token] || Token.new
    if options.include?(:project_id) && options.include?(:iteration_id)
      @id         = options[:iteration_id]
      @project_id = options[:project_id]
      @number     = options[:number]
      @type       = assign_type(options[:type])
      @limit      = options[:limit]
      @offset     = options[:offset]
      @api_url    = build_api_url
      @iteration  = Hpricot(open(@api_url, {"X-TrackerToken" => @token}))
    elsif options.include?(:iteration) && options.include?(:project_id)
      @project_id = options[:project_id]
      @iteration  = options[:iteration]
    else
      raise ArgumentError, "Valid options are: :iteration (receives an Hpricot Object) + :project_id OR :project_id + :iteration_id"
    end
    build_iteration
  end
  
  def start_date(format="%m/%d/%Y")
    @finish_date.strftime(format)
  end
  
  def finish_date(format="%m/%d/%Y")
    @finish_date.strftime(format)
  end
  
  private
  
    def build_iteration
      @id                ||= @iteration.at('id').inner_html
      @number             = @iteration.at('number').inner_html
      @start_date         = Date.parse @iteration.at('start').inner_html
      @finish_date        = Date.parse @iteration.at('finish').inner_html
      @stories            = build_stories
    end
    
    def build_stories
      @stories = (@iteration/'story').map do |story|
         Story.new(:story => story, :project_id => @id, :token => @token)
      end
    end
  
    def build_api_url
      query_string = attributes.map { |key, value| "#{key.to_s}=#{CGI::escape(value)}" unless value.nil?}.compact.join('&')
      url = "#{CONFIG[:api_location]}/projects/#{@project_id}/iterations/#{@type}?"+query_string
      # if !@offset.nil? || !@limit.nil?
      #   url += "?"
      #   url += "offset=#{@offset.to_s}&" if !@offset.nil?
      #   url += "limit=#{@limit.to_s}&" if !@limit.nil?
      # end
      # url
    end
    
    def assign_type(type=nil)
      use_type = nil
      %w{ done current backlog }.each do |valid_type|
        use_type = valid_type if /#{type}/i =~ valid_type
      end
      use_type
    end
    
    def attributes
      {
        :limit => @limit,
        :offset => @offset
      }
    end
  
end