class CompilersController < ApplicationController
  # GET /compilers
  # GET /compilers.xml
  def index
    @compilers = Compiler.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @compilers }
    end
  end

  # GET /compilers/1
  # GET /compilers/1.xml
  def show
    @compiler = Compiler.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @compiler }
    end
  end

  # GET /compilers/new
  # GET /compilers/new.xml
  def new
    @compiler = Compiler.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @compiler }
    end
  end

  # GET /compilers/1/edit
  def edit
    @compiler = Compiler.find(params[:id])
  end

  # POST /compilers
  # POST /compilers.xml
  def create
    @compiler = Compiler.new(params[:compiler])

    respond_to do |format|
      if @compiler.save
        format.html { redirect_to(@compiler, :notice => 'Compiler was successfully created.') }
        format.xml  { render :xml => @compiler, :status => :created, :location => @compiler }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @compiler.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /compilers/1
  # PUT /compilers/1.xml
  def update
    @compiler = Compiler.find(params[:id])

    respond_to do |format|
      if @compiler.update_attributes(params[:compiler])
        format.html { redirect_to(@compiler, :notice => 'Compiler was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @compiler.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /compilers/1
  # DELETE /compilers/1.xml
  def destroy
    @compiler = Compiler.find(params[:id])
    @compiler.destroy

    respond_to do |format|
      format.html { redirect_to(compilers_url) }
      format.xml  { head :ok }
    end
  end
end
