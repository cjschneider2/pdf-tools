defmodule PdfTools.ImageExport do

  @input_dir "./tmp/to-convert"
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
      out_path = Path.join(["./tmp", output_dir, basename])
      File.mkdir_p(out_path)
      # convert
      System.cmd( "pdfimages", [ "-all", "-j", pdf_path, Path.join([out_path, basename])] )
    end
  end

  @doc """
    so apparently adobe saves CMYK jpg's inverted as a default; which are then
    embedded in PDFs made by Adobe products.
    It seems that all other tools except `libpoppler` (and thus `pdfimages`)
    invert CMYK JPGs per default, instead of looking at the flag like poppler does.
    So this method is here to negate JPGs if needed.
  """
  def negate_images_in_dir(dir) do
    File.cd(dir)
    System.cmd("magick mogrifgy", ["-negate", "*.jpg"])
  end

  def convert_mask_to_alpha(image_path, alpha_path, out_path) do
    ## make alpha from two images
    #convert main.png -alpha on \( +clone -channel a -fx 0 \) +swap mask.png -composite out.png
    System.cmd(
      "magick convert",
      [
        image_path,
        "-alpha on",
        "( +clone -channel a -fx 0 )",
        "+swap",
        alpha_path,
        "-composite",
        out_path
      ]
    )
  end

end
