 (:
     This XQuery loads a GCC-XML file and reports the locations of all
     global variables in the original C++ source. To run the query,
     use the command line:

     xmlpatterns reportclassstructure.xq -param fileToOpen=test.xml -output output1.xml

     "fileToOpen=globals.gccxml" binds the file name "globals.gccxml"
     to the variable "fileToOpen" declared and used below.
 :)
declare variable $fileToOpen as xs:anyURI external;

declare function local:findEnumerationType ($typeId as xs:string) as element()* {
      for $type in doc($fileToOpen)//Enumeration[@id = $typeId]
            return <TypeId>{$type}</TypeId>
};

declare function local:findFundamentalTypeId ($typeId as xs:string) as element()* {
      for $fundamentalType in doc($fileToOpen)//FundamentalType[@id = $typeId]
            return <TypeId>{$fundamentalType}</TypeId>
};

declare function local:findClassType ($typeId as xs:string) as element()* {
    for $type in doc($fileToOpen)//Class[@id = $typeId]
          return <TypeId>{$type}</TypeId>
};

declare function local:getTypeDetails ($typeId as xs:string) as element()* {
      let $argumentdetails := local:findFundamentalTypeId($typeId)
      return if ( exists($argumentdetails) )
             then $argumentdetails
             else if (exists(local:findEnumerationType($typeId)))
             then local:findEnumerationType($typeId)
             else if (exists(local:findPointerType($typeId)))
             then local:findPointerType($typeId)
             else if (exists(local:findCvQualifiedType($typeId)))
             then local:findCvQualifiedType($typeId)
             else local:findClassType($typeId)
};

declare function local:findPointerType ($typeId as xs:string) as element()* {
      for $type in doc($fileToOpen)//PointerType[@id = $typeId]
            let $actualType := local:getTypeDetails($type/@type)
            return <TypeId>
                      {$type}
                      {$actualType}
                   </TypeId>
};

declare function local:findCvQualifiedType ($typeId as xs:string) as element()* {
      for $type in doc($fileToOpen)//CvQualifiedType[@id = $typeId]
            let $actualType := local:getTypeDetails($type/@type)
            return <TypeId>
                      {$type}
                      {$actualType}
                   </TypeId>
};

declare function local:argumentDetails ($argument) as element()* {
      for $type in $argument/@type
          let $argumentdetails := local:getTypeDetails($type)
          return $argumentdetails
};

declare function local:argumentsDetails ($method) as element()* {
      for $argument in $method/Argument
          let $details := local:argumentDetails($argument)
          return <Argumentdetails>{$details}</Argumentdetails>
};

declare function local:returnTypeDetails ($method) as element()* {
      let $details := local:getTypeDetails($method/@returns)
      let $moreDetails := () (:local:getTypeDetails($details/@type):)
      return
             <ReturnDetails>
               {$details}
               {$moreDetails}
             </ReturnDetails>
};

declare function local:findFunction ($functionId) as element()* {
      for $method in doc($fileToOpen)//Method[@id = $functionId]
      let $argumentsdetails := local:argumentsDetails($method)
      let $returndetails := local:returnTypeDetails($method)
      return 
             <MethodDetails>
                {$method}
                {$argumentsdetails}
                {$returndetails}
             </MethodDetails>
};

declare function local:method ($methods) as element()* {
      if (count($methods) > 0)
          then
              for $method in $methods
                  return local:findFunction($method)
      else
              ()            
};

declare function local:message ($class) as element()* {
      if (count($class/@members) > 0)
         then
              for $method in $class/@members
                 let $members := tokenize($method, '\s')
                 let $count := count($members)
                 return <methods>{local:method($members)}</methods>
      else
             ()
};
<classes>
{
for $class in doc($fileToOpen)//Class
let $name := $class/@name
let $methods := local:message($class)
return
<class id="{$name}" >
 {$methods}
</class>
}
</classes>
