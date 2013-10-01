class CompilersController < ApplicationController
  before_action :set_compiler, only: [:show, :edit, :update, :destroy]

  # GET /compilers
  # GET /compilers.json
  def index
    @compilers = Compiler.all
  end

  # GET /compilers/1
  # GET /compilers/1.json
  def show
  end

  # GET /compilers/new
  def new
    @compiler = Compiler.new
  end

  # GET /compilers/1/edit
  def edit
  end

  # POST /compilers
  # POST /compilers.json
  def create
    @compiler = Compiler.new(compiler_params)

    respond_to do |format|
      if @compiler.save
        format.html { redirect_to @compiler, notice: 'Compiler was successfully created.' }
        format.json { render action: 'show', status: :created, location: @compiler }
      else
        format.html { render action: 'new' }
        format.json { render json: @compiler.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compilers/1
  # PATCH/PUT /compilers/1.json
  def update
    respond_to do |format|
      if @compiler.update(compiler_params)
        format.html { redirect_to @compiler, notice: 'Compiler was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @compiler.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compilers/1
  # DELETE /compilers/1.json
  def destroy
    @compiler.destroy
    respond_to do |format|
      format.html { redirect_to compilers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compiler
      @compiler = Compiler.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compiler_params
      params.require(:compiler).permit(:name, :command)
    end
end
