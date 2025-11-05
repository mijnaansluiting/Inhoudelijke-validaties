import java.io.File;
import java.lang.invoke.MethodHandles;
import java.nio.file.Path;
import java.util.logging.Logger;
import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

public class XMLValidation {
	static final Logger LOGGER = Logger.getLogger(MethodHandles.lookup().lookupClass().getName());

	public static void main(String[] args) {
		Validator validator;
		File xsdFile;
		File xmlFile;
		try {
			xsdFile = new File(args[0]);
			xmlFile = new File(args[1]);
			SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
			Schema schema = factory.newSchema(xsdFile);
			validator = schema.newValidator();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		System.exit(validate(validator, xmlFile));
	}

	public static int validate(Validator validator, File xmlFile) {
		int error = 0;
		LOGGER.info(String.format("Validating %s", xmlFile.getName()));
		var result = validateXMLSchema(validator, xmlFile);
		if (result != null) {
			error++;
			LOGGER.severe(String.format("Exception while parsing %s: (%s)", xmlFile.getName(), result));
		}
		return error;
	}

	public static String validateXMLSchema(Validator validator, File xmlFile) {
		try {
			validator.validate(new StreamSource(xmlFile));
		} catch (Exception e) {
			return e.getMessage();
		}
		return null;
	}
}
