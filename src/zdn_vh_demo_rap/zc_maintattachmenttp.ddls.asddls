 @AccessControl.authorizationCheck: #NOT_ALLOWED
  @EndUserText.label: 'Maintenance Attachments'
  @Metadata.allowExtensions: true

  define view entity ZC_MaintAttachmentTP
    as projection on ZI_MaintAttachmentTP

  {
    key AttachUUID,
        NotifUUID,

        @EndUserText.label: 'File'
        @Semantics.largeObject: {
          mimeType                    : 'MimeType',
          fileName                    : 'FileName',
          acceptableMimeTypes         : [ 'application/pdf',
                                          'image/png',
                                          'image/jpeg',
                                          'text/plain',
                                          'application/vnd.ms-excel',

  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ],
          contentDispositionPreference: #ATTACHMENT
        }
        FileContent,

        @Semantics.mimeType: true
        MimeType,
        FileName,
        FileSize,

        @Semantics.user.createdBy: true
        CreatedBy,
        @Semantics.systemDateTime.createdAt: true
        CreatedAt,
        @Semantics.user.localInstanceLastChangedBy: true
        LastChangedBy,
        @Semantics.systemDateTime.lastChangedAt: true
        LastChangedAt,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        LocalLastChangedAt,

        _Notification: redirected to parent ZC_MaintNotificationTP
  }
