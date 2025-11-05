<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:keronic="http://example.com/my-functions"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            version="3.0">

  <variable name="language" select= "$user_config_file/config/Language"/>
  <variable name="translation_file" select= "document('../../../localization/messages.xml')"/>

  <function name= "keronic:get-translation">
    <param name="message_id"/>
    <variable name="translation" select="$translation_file//message[@id=$message_id]/message-text[@xml:lang=$language]"/>
    <value-of select="$translation"/>
  </function>

  <function name="keronic:get-translation-and-replace-placeholders">
    <param name="message_id"/>
    <param name="placeholders" as="xs:string*"/> <!-- sequence of strings -->
    <variable name="translation" select="keronic:get-translation($message_id)"/>
    <value-of select="keronic:replace-placeholders($translation, $placeholders)"/>
  </function>

  <function name="keronic:replace-placeholders">
    <param name="message" as="xs:string"/>
    <param name="placeholders" as="xs:string*"/> <!-- sequence of strings -->
    <variable name="result">
      <call-template name="keronic:replace-recursively">
        <with-param name="message" select="$message"/>
        <with-param name="placeholders" select="$placeholders"/>
        <with-param name="index" select="1"/> <!-- start at first placeholder -->
      </call-template>
    </variable>
    <value-of select="$result"/>
  </function>

  <!-- Recursively replace {1}, {2}, ... placeholders -->
  <template name="keronic:replace-recursively">
    <param name="message" as="xs:string"/>
    <param name="placeholders" as="xs:string*"/>
    <param name="index" as="xs:integer"/>

    <choose>
      <when test="$index &lt;= count($placeholders)">
        <variable name="placeholder" select="concat('\{', $index, '\}')"/>
        <variable name="value" select="$placeholders[$index]"/>
        <variable name="new_message" select="replace($message, $placeholder, $value)"/>
        <call-template name="keronic:replace-recursively">
          <with-param name="message" select="$new_message"/>
          <with-param name="placeholders" select="$placeholders"/>
          <with-param name="index" select="$index + 1"/>
        </call-template>
      </when>
      <otherwise>
        <value-of select="$message"/>
      </otherwise>
    </choose>
  </template>
</stylesheet>
