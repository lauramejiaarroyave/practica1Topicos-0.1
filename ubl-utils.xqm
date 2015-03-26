xquery version "3.0";

module namespace ubl="urn:ubl:utils";

declare function ubl:document-list(){
let $doc := doc( '/db/topicos/UBL-2.1.xml' )

(: Obtiene la lista de documentos UBL (las secciones) :)
let $sections := $doc/article/section[3]/section[1]/section

(: obtener los nombres de los documentos :)
for $s in $sections
return <document>
<process>{$s//tbody/row[1]/entry[2]/para/*}</process>
<doc-name>{ $s/title/text() }</doc-name>
</document>
};

declare function ubl:process-list(){
let $list := ubl:document-list()
(: Obtener una lista donde no se repitan elementos con distinct-values() :)
let $ordenado := distinct-values($list//process/link)

return
for $p in $ordenado
return <process><name>{ $p }</name> { ubl:docs-for-process( $list, $p ) }</process>
};

(: Retorna los documentos vinculados a un proceso :)
declare function ubl:docs-for-process( $doc-list, $process-name ){
$doc-list[ process//* = $process-name ]/doc-name
};




declare function ubl:fix-espacios( $name ){
replace( $name, " ", "")
};

declare function ubl:fix-guiones( $name ){
replace( $name, "-", " ")
};


declare function ubl:capitalize($string as xs:string) as xs:string {
  let $tokens := for $codepoint in string-to-codepoints($string) return codepoints-to-string($codepoint)
  return concat(upper-case($tokens[1]), string-join(subsequence($tokens, 2), ''))
};

declare function ubl:fix-name( $name ){
  concat( "UBL-", string-join( for $s in tokenize( $name, " ") return ubl:capitalize($s) ), "-2.1" )
};



