// JCL_DEBUG_EXPERT_INSERTJDBG ON
program FHIRServer3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{
Copyright (c) 2001-2013, Health Intersections Pty Ltd (http://www.healthintersections.com.au)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 * Neither the name of HL7 nor the names of its contributors may be used to
   endorse or promote products derived from this software without specific
   prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
}

{$APPTYPE CONSOLE}

{$R *.res}


{
todo:
STU3 draft:
 - check using UTF-8 in URLs
 - check prefer = operation outcome
 - check turtle support
 - check versioning in capabilities statement
 - check elements & summary on read/vread
 - check delete return codes
 - changes to id element on update
 - check conditional delete flag.
 - search on multiple resource types
 - check over transaction handling
 - dateTIme parameter on history
 - check use of 401 instead of 403
 - check handling of unsupported parameters
 - check implementations of sa and be prefixes in search
 - review searching on names
 - check search by canonical URL and version
 - add searching for token system|
 - reverse chaining
 - check _list parameter
 - check sorting
 - check handling count = 0
 - composite search parameter work
 - test flag support
 - check document operation
 - check handling binary parameter
 - update FHIRPath
 - string validation rules
 - Both _include and _revInclude use the wild card "*" for the search parameter name, indicating that any search parameter of type=reference be included.



https://chat.fhir.org/#narrow/stream/implementers/subject/search.20on.20several.20resource.20types.3F



Add reverse chaining
Grahame, I see you don't respond to either of the following:
 http://hl7connect.healthintersections.com.au/svc/fhir/condition/search?subject=patient/350
 http://hl7connect.healthintersections.com.au/svc/fhir/condition/search?subject=patient/@350
cross resource search
FHIR.Ucum.Base search

}

uses
  FastMM4 in '..\Libraries\FMM\FastMM4.pas',
  Windows,
  SysUtils,
  Classes,
  IdSSLOpenSSLHeaders,
  JclDebug,
  FHIRServerApplicationCore in 'FHIRServerApplicationCore.pas',
  FHIRRestServer in 'FHIRRestServer.pas',
  EncodeSupport in '..\reference-platform\Support\EncodeSupport.pas',
  StringSupport in '..\reference-platform\Support\StringSupport.pas',
  MathSupport in '..\reference-platform\Support\MathSupport.pas',
  SystemSupport in '..\reference-platform\Support\SystemSupport.pas',
  DateSupport in '..\reference-platform\Support\DateSupport.pas',
  MemorySupport in '..\reference-platform\Support\MemorySupport.pas',
  ThreadSupport in '..\reference-platform\Support\ThreadSupport.pas',
  BytesSupport in '..\reference-platform\Support\BytesSupport.pas',
  AdvStringBuilders in '..\reference-platform\Support\AdvStringBuilders.pas',
  AdvObjects in '..\reference-platform\Support\AdvObjects.pas',
  AdvExceptions in '..\reference-platform\Support\AdvExceptions.pas',
  AdvFactories in '..\reference-platform\Support\AdvFactories.pas',
  FileSupport in '..\reference-platform\Support\FileSupport.pas',
  AdvControllers in '..\reference-platform\Support\AdvControllers.pas',
  AdvPersistents in '..\reference-platform\Support\AdvPersistents.pas',
  AdvFilers in '..\reference-platform\Support\AdvFilers.pas',
  ColourSupport in '..\reference-platform\Support\ColourSupport.pas',
  AdvPersistentLists in '..\reference-platform\Support\AdvPersistentLists.pas',
  AdvObjectLists in '..\reference-platform\Support\AdvObjectLists.pas',
  AdvItems in '..\reference-platform\Support\AdvItems.pas',
  AdvCollections in '..\reference-platform\Support\AdvCollections.pas',
  AdvIterators in '..\reference-platform\Support\AdvIterators.pas',
  AdvClassHashes in '..\reference-platform\Support\AdvClassHashes.pas',
  AdvHashes in '..\reference-platform\Support\AdvHashes.pas',
  HashSupport in '..\reference-platform\Support\HashSupport.pas',
  AdvStringHashes in '..\reference-platform\Support\AdvStringHashes.pas',
  AdvStringIntegerMatches in '..\reference-platform\Support\AdvStringIntegerMatches.pas',
  AdvStreams in '..\reference-platform\Support\AdvStreams.pas',
  AdvParameters in '..\reference-platform\Support\AdvParameters.pas',
  AdvFiles in '..\reference-platform\Support\AdvFiles.pas',
  AdvMemories in '..\reference-platform\Support\AdvMemories.pas',
  AdvBuffers in '..\reference-platform\Support\AdvBuffers.pas',
  AdvStreamFilers in '..\reference-platform\Support\AdvStreamFilers.pas',
  AdvExclusiveCriticalSections in '..\reference-platform\Support\AdvExclusiveCriticalSections.pas',
  AdvThreads in '..\reference-platform\Support\AdvThreads.pas',
  AdvSignals in '..\reference-platform\Support\AdvSignals.pas',
  AdvInt64Matches in '..\reference-platform\Support\AdvInt64Matches.pas',
  AdvLargeIntegerMatches in '..\reference-platform\Support\AdvLargeIntegerMatches.pas',
  AdvStringLargeIntegerMatches in '..\reference-platform\Support\AdvStringLargeIntegerMatches.pas',
  AdvStringLists in '..\reference-platform\Support\AdvStringLists.pas',
  AdvCSVFormatters in '..\reference-platform\Support\AdvCSVFormatters.pas',
  AdvTextFormatters in '..\reference-platform\Support\AdvTextFormatters.pas',
  AdvFormatters in '..\reference-platform\Support\AdvFormatters.pas',
  AdvCSVExtractors in '..\reference-platform\Support\AdvCSVExtractors.pas',
  AdvTextExtractors in '..\reference-platform\Support\AdvTextExtractors.pas',
  AdvExtractors in '..\reference-platform\Support\AdvExtractors.pas',
  AdvCharacterSets in '..\reference-platform\Support\AdvCharacterSets.pas',
  AdvOrdinalSets in '..\reference-platform\Support\AdvOrdinalSets.pas',
  AdvStreamReaders in '..\reference-platform\Support\AdvStreamReaders.pas',
  AdvStringStreams in '..\reference-platform\Support\AdvStringStreams.pas',
  AdvStringMatches in '..\reference-platform\Support\AdvStringMatches.pas',
  AdvXMLEntities in '..\reference-platform\Support\AdvXMLEntities.pas',
  AdvXMLFormatters in '..\reference-platform\Support\AdvXMLFormatters.pas',
  ParseMap in '..\reference-platform\Support\ParseMap.pas',
  AdvZipParts in '..\reference-platform\Support\AdvZipParts.pas',
  AdvNameBuffers in '..\reference-platform\Support\AdvNameBuffers.pas',
  AdvZipReaders in '..\reference-platform\Support\AdvZipReaders.pas',
  AdvVCLStreams in '..\reference-platform\Support\AdvVCLStreams.pas',
  AdvZipDeclarations in '..\reference-platform\Support\AdvZipDeclarations.pas',
  AdvZipUtilities in '..\reference-platform\Support\AdvZipUtilities.pas',
  AdvZipWorkers in '..\reference-platform\Support\AdvZipWorkers.pas',
  GUIDSupport in '..\reference-platform\Support\GUIDSupport.pas',
  DecimalSupport in '..\reference-platform\Support\DecimalSupport.pas',
  HL7V2DateSupport in '..\reference-platform\Support\HL7V2DateSupport.pas',
  MsXmlParser in '..\reference-platform\Support\MsXmlParser.pas',
  XMLBuilder in '..\reference-platform\Support\XMLBuilder.pas',
  AdvWinInetClients in '..\reference-platform\Support\AdvWinInetClients.pas',
  AdvXmlBuilders in '..\reference-platform\Support\AdvXmlBuilders.pas',
  AdvJSON in '..\reference-platform\Support\AdvJSON.pas',
  AfsResourceVolumes in '..\reference-platform\Support\AfsResourceVolumes.pas',
  AfsVolumes in '..\reference-platform\Support\AfsVolumes.pas',
  AfsStreamManagers in '..\reference-platform\Support\AfsStreamManagers.pas',
  AdvObjectMatches in '..\reference-platform\Support\AdvObjectMatches.pas',
  TextUtilities in '..\reference-platform\Support\TextUtilities.pas',
  AdvIntegerObjectMatches in '..\reference-platform\Support\AdvIntegerObjectMatches.pas',
  AdvStringObjectMatches in '..\reference-platform\Support\AdvStringObjectMatches.pas',
  FHIRIndexManagers in 'FHIRIndexManagers.pas',
  AdvNames in '..\reference-platform\Support\AdvNames.pas',
  FHIR.Ucum.Services in '..\Libraries\Ucum\FHIR.Ucum.Services.pas',
  AdvClassLists in '..\reference-platform\Support\AdvClassLists.pas',
  AdvPointers in '..\reference-platform\Support\AdvPointers.pas',
  FHIR.Ucum.Handlers in '..\Libraries\Ucum\FHIR.Ucum.Handlers.pas',
  FHIR.Ucum.Base in '..\Libraries\Ucum\FHIR.Ucum.Base.pas',
  FHIR.Ucum.Validators in '..\Libraries\Ucum\FHIR.Ucum.Validators.pas',
  FHIR.Ucum.Expressions in '..\Libraries\Ucum\FHIR.Ucum.Expressions.pas',
  FHIR.Ucum.Search in '..\Libraries\Ucum\FHIR.Ucum.Search.pas',
  FHIRValueSetExpander in 'FHIRValueSetExpander.pas',
  YuStemmer in '..\Libraries\Stem\YuStemmer.pas',
  FHIR.Loinc.Services in '..\Libraries\loinc\FHIR.Loinc.Services.pas',
  DISystemCompat in '..\Libraries\Stem\DISystemCompat.pas',
  FHIR.Snomed.Services in '..\Libraries\Snomed\FHIR.Snomed.Services.pas',
  InternetFetcher in '..\reference-platform\Support\InternetFetcher.pas',
  FacebookSupport in '..\reference-platform\Support\FacebookSupport.pas',
  SystemService in '..\reference-platform\Support\SystemService.pas',
  ServiceController in '..\reference-platform\Support\ServiceController.pas',
  AdvIntegerLists in '..\reference-platform\Support\AdvIntegerLists.pas',
  AdvDispatchers in '..\reference-platform\Support\AdvDispatchers.pas',
  AdvEvents in '..\reference-platform\Support\AdvEvents.pas',
  AdvMethods in '..\reference-platform\Support\AdvMethods.pas',
  DBInstaller in 'DBInstaller.pas',
  KDBDialects in '..\reference-platform\Support\KDBDialects.pas',
  FHIR.Database.Logging in '..\Libraries\db\FHIR.Database.Logging.pas',
  FHIR.Database.Manager in '..\Libraries\db\FHIR.Database.Manager.pas',
  FHIR.Database.Utilities in '..\Libraries\db\FHIR.Database.Utilities.pas',
  FHIR.Database.Settings in '..\Libraries\db\FHIR.Database.Settings.pas',
  CurrencySupport in '..\reference-platform\Support\CurrencySupport.pas',
  FHIRNativeStorage in 'FHIRNativeStorage.pas',
  FHIR.Snomed.Importer in '..\Libraries\snomed\FHIR.Snomed.Importer.pas',
  AdvProfilers in '..\reference-platform\Support\AdvProfilers.pas',
  AnsiStringBuilder in '..\reference-platform\Support\AnsiStringBuilder.pas',
  AdvIntegerMatches in '..\reference-platform\Support\AdvIntegerMatches.pas',
  FHIR.Snomed.Publisher in '..\Libraries\snomed\FHIR.Snomed.Publisher.pas',
  FHIR.Snomed.Expressions in '..\Libraries\snomed\FHIR.Snomed.Expressions.pas',
  HTMLPublisher in '..\reference-platform\Support\HTMLPublisher.pas',
  FHIR.Loinc.Importer in '..\Libraries\loinc\FHIR.Loinc.Importer.pas',
  FHIR.Loinc.Publisher in '..\Libraries\loinc\FHIR.Loinc.Publisher.pas',
  TerminologyServer in 'TerminologyServer.pas',
  TerminologyServerStore in 'TerminologyServerStore.pas',
  TerminologyServices in '..\Libraries\TerminologyServices.pas',
  FHIRValueSetChecker in 'FHIRValueSetChecker.pas',
  TerminologyWebServer in 'TerminologyWebServer.pas',
  FHIRServerConstants in 'FHIRServerConstants.pas',
  FHIRServerUtilities in 'FHIRServerUtilities.pas',
  SearchProcessor in 'SearchProcessor.pas',
  AuthServer in 'AuthServer.pas',
  libeay32 in '..\reference-platform\Support\libeay32.pas',
  HMAC in '..\reference-platform\Support\HMAC.pas',
  JWT in '..\reference-platform\Support\JWT.pas',
  SCIMServer in 'SCIMServer.pas',
  SCIMSearch in 'SCIMSearch.pas',
  FHIR.Misc.Twilio in '..\Libraries\security\FHIR.Misc.Twilio.pas',
  FHIRSearchSyntax in 'FHIRSearchSyntax.pas',
  ShellSupport in '..\reference-platform\Support\ShellSupport.pas',
  RectSupport in 'RectSupport.pas',
  CoordinateSupport in 'CoordinateSupport.pas',
  AdvGenerics in '..\reference-platform\Support\AdvGenerics.pas',
  XMLSupport in '..\reference-platform\Support\XMLSupport.pas',
  DigitalSignatures in '..\reference-platform\Support\DigitalSignatures.pas',
  UriServices in 'UriServices.pas',
  UniiServices in 'UniiServices.pas',
  RxNormServices in 'RxNormServices.pas',
  OIDSupport in '..\reference-platform\Support\OIDSupport.pas',
  IETFLanguageCodeServices in 'IETFLanguageCodeServices.pas',
  FHIR.Snomed.Analysis in '..\Libraries\snomed\FHIR.Snomed.Analysis.pas',
  AreaCodeServices in 'AreaCodeServices.pas',
  FHIRSubscriptionManager in 'FHIRSubscriptionManager.pas',
  ServerValidator in 'ServerValidator.pas',
  IdWebSocket in '..\reference-platform\Support\IdWebSocket.pas',
  MimeMessage in '..\reference-platform\Support\MimeMessage.pas',
  kCritSct in '..\reference-platform\Support\kCritSct.pas',
  QuestionnaireBuilder3 in '..\reference-platform\dstu3\QuestionnaireBuilder3.pas',
  SCIMObjects in '..\reference-platform\support\SCIMObjects.pas',
  NarrativeGenerator3 in '..\reference-platform\dstu3\NarrativeGenerator3.pas',
  FHIRSecurity in '..\reference-platform\support\FHIRSecurity.pas',
  FHIRNarrativeGenerator3 in '..\reference-platform\dstu3\FHIRNarrativeGenerator3.pas',
  SmartOnFhirUtilities in '..\reference-platform\client\SmartOnFhirUtilities.pas',
  FhirPath3 in '..\reference-platform\dstu3\FhirPath3.pas',
  FHIRTags3 in '..\reference-platform\dstu3\FHIRTags3.pas',
  FHIRProfileUtilities3 in '..\reference-platform\dstu3\FHIRProfileUtilities3.pas',
  FHIRBase in '..\reference-platform\support\FHIRBase.pas',
  FHIRTypes3 in '..\reference-platform\dstu3\FHIRTypes3.pas',
  FHIRResources3 in '..\reference-platform\dstu3\FHIRResources3.pas',
  FHIRParser in '..\reference-platform\support\FHIRParser.pas',
  FHIRParserXml3 in '..\reference-platform\dstu3\FHIRParserXml3.pas',
  FHIRParserJson3 in '..\reference-platform\dstu3\FHIRParserJson3.pas',
  FHIRParserTurtle3 in '..\reference-platform\dstu3\FHIRParserTurtle3.pas',
  FHIRParserBase in '..\reference-platform\support\FHIRParserBase.pas',
  FHIRConstants3 in '..\reference-platform\dstu3\FHIRConstants3.pas',
  FHIRSupport in '..\reference-platform\support\FHIRSupport.pas',
  FHIRLang in '..\reference-platform\support\FHIRLang.pas',
  FHIRUtilities3 in '..\reference-platform\dstu3\FHIRUtilities3.pas',
  FHIRClient in '..\reference-platform\client\FHIRClient.pas',
  FHIRValidator3 in '..\reference-platform\dstu3\FHIRValidator3.pas',
  ClosureManager in 'ClosureManager.pas',
  CDSHooksUtilities in '..\reference-platform\support\CDSHooksUtilities.pas',
  MarkdownProcessor in '..\..\markdown\source\MarkdownProcessor.pas',
  MarkdownDaringFireball in '..\..\markdown\source\MarkdownDaringFireball.pas',
  MarkdownDaringFireballTests in '..\..\markdown\source\MarkdownDaringFireballTests.pas',
  AccessControlEngine in 'AccessControlEngine.pas',
  MPISearch in 'MPISearch.pas',
  RDFUtilities in '..\reference-platform\support\RDFUtilities.pas',
  FHIROperations3 in '..\reference-platform\dstu3\FHIROperations3.pas',
  FhirOpBase3 in '..\reference-platform\dstu3\FhirOpBase3.pas',
  FHIRIndexInformation3 in '..\reference-platform\dstu3\FHIRIndexInformation3.pas',
  FHIRMetaModel3 in '..\reference-platform\dstu3\FHIRMetaModel3.pas',
  FHIRXhtml in '..\reference-platform\support\FHIRXhtml.pas',
  FHIRStructureMapUtilities3 in '..\reference-platform\dstu3\FHIRStructureMapUtilities3.pas',
  FHIRContext3 in '..\reference-platform\dstu3\FHIRContext3.pas',
  XmlPatch in '..\reference-platform\support\XmlPatch.pas',
  FHIRLog in '..\reference-platform\support\FHIRLog.pas',
  FHIRAuthMap3 in '..\reference-platform\dstu3\FHIRAuthMap3.pas',
  AdvZipWriters in '..\reference-platform\support\AdvZipWriters.pas',
  ObservationStatsEvaluator in 'ObservationStatsEvaluator.pas',
  OpenMHealthServer in 'OpenMHealthServer.pas',
  DifferenceEngine in '..\reference-platform\support\DifferenceEngine.pas',
  ACIRServices in 'ACIRServices.pas',
  ReverseClient in 'ReverseClient.pas',
  FHIRStorageService in 'FHIRStorageService.pas',
  FHIRServerContext in 'FHIRServerContext.pas',
  ExampleBridge in '..\bridge\ExampleBridge.pas',
  FHIRSessionManager in 'FHIRSessionManager.pas',
  FHIRTagManager in 'FHIRTagManager.pas',
  FHIRUserProvider in 'FHIRUserProvider.pas',
  GraphQL in '..\reference-platform\support\GraphQL.pas',
  FastMM4Messages in '..\Libraries\FMM\FastMM4Messages.pas',
  FHIRGraphQL in '..\reference-platform\support\FHIRGraphQL.pas',
  ParserSupport in '..\reference-platform\support\ParserSupport.pas',
  MXML in '..\reference-platform\support\MXML.pas',
  MXmlBuilder in '..\reference-platform\support\MXmlBuilder.pas',
  MarkdownCommonMark in '..\..\markdown\source\MarkdownCommonMark.pas',
  FHIRCodeGenerator in '..\reference-platform\support\FHIRCodeGenerator.pas',
  CDSHooksServer in 'CDSHooksServer.pas',
  CDSHooksServices in 'CDSHooksServices.pas',
  TurtleParser in '..\reference-platform\support\TurtleParser.pas',
  CertificateSupport in '..\reference-platform\support\CertificateSupport.pas',
  FHIR.Misc.ApplicationVerifier in '..\Libraries\security\FHIR.Misc.ApplicationVerifier.pas',
  JWTService in 'JWTService.pas',
  CDSHooksClientManager in '..\reference-platform\support\CDSHooksClientManager.pas',
  HackingHealthLogic in 'Modules\HackingHealthLogic.pas',
  ApplicationCache in 'ApplicationCache.pas',
  FHIR.Utilities.SCrypt in '..\Libraries\security\FHIR.Utilities.SCrypt.pas',
  TerminologyOperations in 'TerminologyOperations.pas',
  WebSourceProvider in 'WebSourceProvider.pas',
  FHIRIndexBase in '..\reference-platform\support\FHIRIndexBase.pas',
  ErrorSupport in '..\reference-platform\Support\ErrorSupport.pas',
  FHIR.Database.ODBC in '..\Libraries\db\FHIR.Database.ODBC.pas',
  FHIR.Database.ODBC.Objects in '..\Libraries\db\FHIR.Database.ODBC.Objects.pas',
  FHIR.Database.ODBC.Headers in '..\Libraries\db\FHIR.Database.ODBC.Headers.pas',
  FHIR.Database.SQLite in '..\Libraries\db\FHIR.Database.SQLite.pas',
  FHIR.Database.SQLite3.Wrapper in '..\Libraries\db\FHIR.Database.SQLite3.Wrapper.pas',
  FHIR.Database.SQLite3.Objects in '..\Libraries\db\FHIR.Database.SQLite3.Objects.pas',
  FHIR.Database.SQLite3.Utilities in '..\Libraries\db\FHIR.Database.SQLite3.Utilities.pas',
  QuestionnaireRenderer3 in '..\reference-platform\dstu3\QuestionnaireRenderer3.pas',
  FHIRDeIdentifier in '..\reference-platform\common\FHIRDeIdentifier.pas',
  ServerPostHandlers in 'ServerPostHandlers.pas',
  ICD10Services in 'ICD10Services.pas',
  FHIR.Javascript.Base in '..\Libraries\js\FHIR.Javascript.Base.pas',
  FHIRJavascriptReg3 in '..\reference-platform\dstu3\FHIRJavascriptReg3.pas',
  FHIR.Support.Javascript in '..\Libraries\js\FHIR.Support.Javascript.pas',
  ServerJavascriptHost in 'ServerJavascriptHost.pas',
  ServerEventJs in 'ServerEventJs.pas',
  FHIR.Javascript in '..\Libraries\js\FHIR.Javascript.pas',
  FHIR.Javascript.Chakra in '..\Libraries\js\FHIR.Javascript.Chakra.pas',
  FHIR.Client.Javascript in '..\Libraries\js\FHIR.Client.Javascript.pas',
  FHIRFactory in '..\reference-platform\support\FHIRFactory.pas',
  Logging in 'Logging.pas',
  CountryCodeServices in 'CountryCodeServices.pas',
  USStatesServices in 'USStatesServices.pas',
  GoogleAnalyticsProvider in 'GoogleAnalyticsProvider.pas',
  FHIRPathNode3 in '..\reference-platform\dstu3\FHIRPathNode3.pas',
  UcumServiceInterface in '..\reference-platform\support\UcumServiceInterface.pas',
  FHIRBase3 in '..\reference-platform\dstu3\FHIRBase3.pas',
  FHIRXhtmlComposer in '..\reference-platform\Support\FHIRXhtmlComposer.pas',
  FHIRParserBase3 in '..\reference-platform\dstu3\FHIRParserBase3.pas',
  FHIRParser3 in '..\reference-platform\dstu3\FHIRParser3.pas',
  FhirVersionConvertors in '..\reference-platform\xversion\FhirVersionConvertors.pas',
  VersionConvertor_30_40 in '..\reference-platform\xversion\VersionConvertor_30_40.pas',
  FHIRResources4 in '..\reference-platform\r4\FHIRResources4.pas',
  FHIRParser4 in '..\reference-platform\r4\FHIRParser4.pas',
  FHIRBase4 in '..\reference-platform\r4\FHIRBase4.pas',
  FHIRTypes4 in '..\reference-platform\r4\FHIRTypes4.pas',
  FHIRMetaModel4 in '..\reference-platform\r4\FHIRMetaModel4.pas',
  FHIRUtilities4 in '..\reference-platform\r4\FHIRUtilities4.pas',
  FHIRContext4 in '..\reference-platform\r4\FHIRContext4.pas',
  FHIRConstants4 in '..\reference-platform\r4\FHIRConstants4.pas',
  FHIRPathNode4 in '..\reference-platform\r4\FHIRPathNode4.pas',
  FHIRProfileUtilities4 in '..\reference-platform\r4\FHIRProfileUtilities4.pas',
  FHIRParserXml4 in '..\reference-platform\r4\FHIRParserXml4.pas',
  FHIRParserBase4 in '..\reference-platform\r4\FHIRParserBase4.pas',
  FHIRParserJson4 in '..\reference-platform\r4\FHIRParserJson4.pas',
  FHIRParserTurtle4 in '..\reference-platform\r4\FHIRParserTurtle4.pas',
  FHIRClient3 in '..\reference-platform\dstu3\FHIRClient3.pas',
  FHIRClientBase in '..\reference-platform\client\FHIRClientBase.pas',
  FHIRClientHTTP in '..\reference-platform\client\FHIRClientHTTP.pas',
  FHIRClientThreaded in '..\reference-platform\client\FHIRClientThreaded.pas';

begin
  logfile := IncludeTrailingPathDelimiter(SystemTemp)+'fhirserver.log';
  if ParamCount = 0 then
  begin
    filelog := true;
    logt('testing');
  end;
  JclStartExceptionTracking;
  IdOpenSSLSetLibPath(ExtractFilePath(Paramstr(0)));
  try
    SetConsoleTitle('FHIR Server R3');
    ExecuteFhirServer;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
    end;
  end;
end.


