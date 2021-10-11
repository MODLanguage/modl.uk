require 'sinatra'

def compare_formats(header,code_samples)
  ## Change spaces for hyphens, removes slashes, ampersands and exclamations
  header_id = header.gsub(/\W+/, '').downcase

  print_comparison = "
    <div id='#{header_id}' class='sectionh4'>
      <h4 id='#{header_id}-title'>#{header}</h4>
      <div class='row'>"

  shortest_option = 99999
  most_line_breaks = 0
  for code_sample in code_samples
    code_sample = remove_indenting(code_sample)
    code_sample = code_sample.gsub("<span>","") 
    code_sample = code_sample.gsub("</span>","") 
    code_sample = code_sample.gsub('\"','"')     
    this_length = code_sample.length
    if this_length < shortest_option
      shortest_option = this_length
    end
    line_breaks = code_sample.count("\n")
    if line_breaks > most_line_breaks
      most_line_breaks = line_breaks
    end
  end 

  counter = 1
  for code_sample in code_samples
    code_sample = remove_indenting(code_sample)
    code_length = code_sample.length

    if counter == 1
      code_type = "JSON"
      comparison_style = "first"
      json_length = code_length
    elsif counter == 2
      code_type = "YAML"
      comparison_style = "second"
    elsif counter == 3
      code_type = "MODL"
      comparison_style = "third"
    end

    if counter > 1
      diff_length = ( ( (json_length.to_f - code_length.to_f) / json_length.to_f ) * 100 ).to_i
      if diff_length < 0
        less_more = "more"
        diff_length = 0-diff_length
      else
        less_more = "less"
      end
      diff = "(#{diff_length}% #{less_more})"
    end

    if code_length == shortest_option
      shortest_class = " shortest"
    else
      shortest_class = ""
    end

    code_sample.gsub!("\n","<br>")
    code_sample.gsub!(" ","&nbsp;")

    line_breaks = code_sample.count("<br>")
    line_padding = most_line_breaks - line_breaks
    add_new_lines = ""
    line_padding.times do
      add_new_lines << "<span class='nm'>&nbsp;<br></span>"
    end

    print_comparison << "
      <div class='col-4 col-s-4'>
        <div class='comparison #{comparison_style}'>
          <div class='header'>#{code_type}</div>"

    if code_length < 30
      print_comparison << "<div>#{code_sample}#{add_new_lines}</div>"
    end

    print_comparison << "
          <div class='count#{shortest_class}'>#{code_length} chars#{diff}</div>
        </div>
      </div>"
    counter += 1
  end 
  print_comparison << "</div></div>" 
end

def run_reminder()
  "<p class='reminder'>Tip: Wherever you see the run icon (<img src='/images/run-icon.png' alt='run icon'>) you can click the icon to run the code in a mini playground window.</p>"
end

def compare_language(divname,code_array,div_height=nil,show_copy=nil,show_run=nil,selected_code="modl",show_count=false)
  most_newlines = 0
  for code in code_array
    if code!=nil
      newline_count = code.count("\n")
      if newline_count > most_newlines
        most_newlines = newline_count
      end
    end
  end

  output = ""
  output_li = ""

  code_array.each_with_index do |code,i|
    code_name = ""
    if i == 0 then
      code_name = "modl"
    elsif i == 1 then
      code_name = "json"
      show_run = false
    elsif i == 2 then
      code_name = "yaml"
    end

    if code_name == selected_code then
      selected_addition = " selected"
      if div_height != nil then
        style_addition = " style='height:#{div_height}px;overflow:scroll;display:block'"
      else
        style_addition = " style='display:block'"
      end
    else
      selected_addition = ""      
      style_addition = " style='display:none'"
    end

    if code != nil then
      code = remove_indenting(code)

      code_stripped = code.gsub("<span>","") 
      code_stripped = code_stripped.gsub("</span>","") 
      code_stripped = code_stripped.gsub('\"','"') 

      character_count = code_stripped.length.to_i

      if div_height == nil then
        newline_count = code.count("\n")
        extra_newlines = most_newlines - newline_count

        extra_newlines = "\n"*(extra_newlines)
      else
        extra_newlines = ""
      end

      if show_count then
        count_string = '<span class="nm">&nbsp;(' + character_count.to_s + ' chars)</span></li>'
      else
        count_string = ''
      end

      output <<   '<div class="print print-header">' + code_name.upcase + '</div><div id="' + divname + '-' + code_name + '-code" class="code-shown ' + code_name + '-code"' + style_addition + '>' +
                    code_with_note(divname+"-"+code_name+"-code",code+extra_newlines,nil,div_height,show_copy,show_run) +
                  '</div>'
      output_li << '<li id="' + divname + '-' + code_name + '" class="' + code_name + selected_addition + '"data-which="' + code_name + '">' + code_name.upcase + count_string
      extra_newlines = newline_count - code.count("\n")
    end
  end

  output << '
  <div class="language-choice">
    <ul>'+output_li+'</ul>
  </div>'
end

def remove_indenting(code)
  if code[0] != "\n"
    # If the code isn't prefixed with a newline then add one
    code = "\n#{code}"
  end
  # Find out what the code indenting is
  prefixed_spaces = code[/\A\n */].size-1
  # Remove the spacing
  code = code.gsub("\n" + (" "*prefixed_spaces),"\n")
  # Remove the first newline
  code = code.sub(/\A\n/,"")
end

def code_with_note(code_id,code,note=nil,div_height=nil,show_copy=true,show_run=true)
  # The code passed to this function may be prefixed with a newline and extra spacing
  # (for code readibility) but we don't want that to appear in the output because it's in an
  # HTML pre element
  # 
  if code[0] != "\n"
    # If the code isn't prefixed with a newline then add one
    code = "\n#{code}"
  end
  # Find out what the code indenting is
  prefixed_spaces = code[/\A\n */].size-1
  # Remove the spacing
  code = code.gsub("\n" + (" "*prefixed_spaces),"\n")
  # Remove the first newline
  code = code.sub(/\A\n/,"")
  if div_height != nil then
    style_addition = " style='height:#{div_height}px;overflow:scroll;'"
  else
    style_addition = ""
  end

  if show_copy and show_run
    copy_style = " style='margin-right: 20px;'"
    run_style = " style='margin-right: 0px;'"
  end

  if show_copy
    copy_div = "<div class='copy-code code_name' data-code='#{code_id}'#{copy_style}><img src='/images/copy-icon.png' alt='copy to clipboard'></div>"
  else
    copy_div = ""
  end

  if show_run
    run_div = "<div class='run-code' data-code='#{code_id}'#{run_style}><img src='/images/run-icon.png' alt='run code'></div>"
  else
    run_div = ""
  end

  if note == nil
    to_print = "#{run_div}#{copy_div}<div class='console-no-note'#{style_addition}>#{code}</div>"
  else
    to_print = "#{run_div}#{copy_div}<div class='console' id='#{code_id}'>#{code}</div>\n<div class='note'>#{note}</div>"
  end
end

def link_icon(type)
  if type == 'up'
    title = 'Content further up this document.'
    target_addition = ''
  elsif type == 'down'
    title = 'Content further down this document.'
    target_addition = ''
  elsif type == 'internal'
    title = 'Content elsewhere on this site.'
    target_addition = ''
  elsif type == 'external'
    title = 'Content on another site.'
    target_addition = ' target="blank"'
  end

  "<img src='/images/link-#{type}.png' class='link-#{type}' title='#{title}' alt='#{title}'>"
end

def platform_choice(divname,code)
  '<div class="platform-choice">
    <ul>
      <li id="' + divname + '-win" class="win" data-which="win">Windows Users</li>
      <li id="' + divname + '-unix" class="unix selected" data-which="unix">Everyone Else</li>
    </lu>
  </div>
  <div id="' + divname + '-win-code" class="win-code">' +
    code_with_note("code-"+divname+"-win",code[0][0],code[0][1],false,true,false) +
  '</div>
  <div id="' + divname + '-unix-code" class="unix-code">' +
    code_with_note("code-"+divname+"-linux",code[1][0],code[1][1],false,true,false) + 
  '</div>'
end

before do

  full_route = request.env['PATH_INFO']
  do_redirect = false
  host_domain = request.host
  is_local = false
  is_aws_domain = false

  if host_domain == "localhost" or host_domain == "0.0.0.0"
    is_local = true
  elsif host_domain == "modldotuk-env.eba-93guexca.eu-west-2.elasticbeanstalk.com"
    is_aws_domain = true
  end

  if !request.secure? and !is_local and !is_aws_domain
    do_redirect = true
  else
    if host_domain[0...4] != "www." and !is_local and !is_aws_domain
      do_redirect = true
      host_domain = "www.#{request.host}"
    end
  end

  if do_redirect
    redirect "https://#{host_domain}#{full_route}", 301
  end

  page_name = full_route.reverse.chop.reverse  
  if page_name == ""
    page_name = "home"
  end
  @page_name = page_name
  @page_style = false
  response.headers['Access-Control-Allow-Origin'] = '*'  
end

@author_name = "Elliott Brown"

get '/' do
  @page_style = true
  erb :home
end

get '/specification' do
  @page_style = true
  @mini_playground = true
  erb :specification
end

get '/libraries' do
  erb :libraries
end

get '/playground' do
  @page_style = true
  erb :playground
end

post '/playground' do
  @page_style = true
  erb :playground
end

get '/mini-playground' do
  @page_style = true
  erb :mini_playground, :layout => false
end

post '/mini-playground' do
  @page_style = true
  erb :mini_playground, :layout => false
end

get '/library-alerts' do
  @page_style = true
  erb :library_alerts
end