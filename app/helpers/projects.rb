class Main
  helpers do
    def show_date(date)
      if (date.nil?)
        haml "%span.emphasis none", :layout => false
      else
        full_date = date.strftime("%m-%d-%Y")
        haml "%span{:title => #{full_date} #{nice_date(date)}", :layout => false
      end
    end
  end
end