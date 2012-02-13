package UpdatePipeline::Exceptions;

use Exception::Class (
    UpdatePipeline::Exceptions::UnknownCommonName     => { description => 'The sample has a common name which is not in our list of valid names' },
    UpdatePipeline::Exceptions::CouldntCreateProject  => { description => 'Couldnt create a row in VRTrack for project' },
    UpdatePipeline::Exceptions::CouldntCreateLibrary  => { description => 'Couldnt create a row in VRTrack for library' },
    UpdatePipeline::Exceptions::CouldntCreateSample   => { description => 'Couldnt create a row in VRTrack for sample' },
    UpdatePipeline::Exceptions::CouldntCreateStudy    => { description => 'Couldnt create a row in VRTrack for study' },
);

1;
