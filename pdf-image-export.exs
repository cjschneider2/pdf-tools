
defmodule PdfImageExport do

  @input_dir "./to-convert"
  @output_dir "output-images"

  def get_source_files(dir \\ @input_dir) do
    full_path = Path.expand(dir)
    Path.wildcard(full_path <> "/*.pdf")
  end

  def rip_pdf_images(pdf_path_list, output_dir \\ @output_dir) do
    # convert pdfs in list according to folder
    for pdf_path <- pdf_path_list do
      # setup output directory for pdf
      basename = Path.basename(pdf_path, ".pdf")
      out_path = Path.join([".", output_dir, basename])
      File.mkdir_p(out_path)
      # convert
      System.cmd( "pdfimages", [ "-all", "-j", pdf_path, Path.join([out_path, basename])] )
    end
  end

  @
  def negate_image(img_path) do
    ## negate images
    #for d in ./*/ ; do (cd "$d" && magick mogrify -negate *.jpg); done
  end

  def convert_mask_to_alpha(image_path, alpha_path) do
    ## make alpha from two images
    #convert main.png -alpha on \( +clone -channel a -fx 0 \) +swap mask.png -composite out.png
  end

end
