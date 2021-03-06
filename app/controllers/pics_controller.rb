class PicsController < ApplicationController
  # GET /pics
  # GET /pics.xml
  def index
    @pics = Pic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pics }
    end
  end

  # GET /pics/1
  # GET /pics/1.xml
  def show
    @pic = Pic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pic }
    end
  end

  # GET /pics/new
  # GET /pics/new.xml
  def new
    @pic = Pic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pic }
    end
  end

  # GET /pics/1/edit
  def edit
    @pic = Pic.find(params[:id])
  end

  # POST /pics
  # POST /pics.xml
  def create
    @pic = Pic.new(params[:pic])

    respond_to do |format|
      if @pic.save
        format.html { redirect_to(@pic, :notice => 'Pic was successfully created.') }
        format.xml  { render :xml => @pic, :status => :created, :location => @pic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pics/1
  # PUT /pics/1.xml
  def update
    @pic = Pic.find(params[:id])

    respond_to do |format|
      if @pic.update_attributes(params[:pic])
        format.html { redirect_to(@pic, :notice => 'Pic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pics/1
  # DELETE /pics/1.xml
  def destroy
    @pic = Pic.find(params[:id])
    @pic.destroy

    respond_to do |format|
      format.html { redirect_to(pics_url) }
      format.xml  { head :ok }
    end
  end
  
  def browse
    @pic = Pic.find(params[:id]) 
    # @other_pics = Pic.find(:all, :order => 'weight DESC')
    links = @pic.links.find(:all,  :order => 'weight DESC')
    @other_pics = []
    links.each do |l|
      @other_pics << Pic.find(params[:id])
    end
    # debugger
    
    
    if @other_pics.size < 20 then 
      Pic.all.each do |p|
        @other_pics << p
      end
    end
    # @other_pics.each do |e|
    #   puts e.pic.id.to_s + " + " + e.weight.to_s
    # end
    # TODO - will need some proper size checking in here later (i.e. to match number of images with table dimensions)
    # puts @other_pics
    @max_table_width = 2
    
  end
  
  def build_link
    @pic = Pic.find(params[:id])
    from = Pic.find(session[:previous]) 
    puts "@pic "+@pic.id.to_s
    puts "from "+from.id.to_s
    if @pic.id == from.id
      then
    else
      @found ||= Link.where({:pic_id => from.id, :to_pic => @pic.id}).first
      if @found 
        @found.weight += 1
        @found.save
        else
        Link.new(:pic_id => from.id, :to_pic => @pic.id, :weight => 1).save
      end
    end
    redirect_to :controller => 'pics', :action  => 'browse', :id => @pic.id
  end
  
  def import
    basedir = "#{RAILS_ROOT}/public/import/"
    Dir.new(basedir).entries.each do |file|
      if File.directory? file
      else
        # puts file
        start = file.split('.')[0]
        if Pic.find_by_filename(start).blank?
          Pic.new(:filename => start).save
        else
        end
      end
    end
  end
end
