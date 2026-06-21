@AccessControl.authorizationCheck: #NOT_ALLOWED
  @EndUserText.label: 'Maintenance Notification Attachments'
  @Metadata.allowExtensions: true

  define view entity ZI_MaintAttachmentTP
    as select from zmaint_attachm as Attachment

    association to parent ZR_MaintNotificationTP as _Notification
      on $projection.NotifUUID = _Notification.NotifUUID

  {
    key attach_uuid           as AttachUUID,
        notif_uuid            as NotifUUID,
        file_content          as FileContent,
        mime_type             as MimeType,
        file_name             as FileName,
        file_size             as FileSize,

        @Semantics.user.createdBy: true
        created_by            as CreatedBy,
        @Semantics.systemDateTime.createdAt: true
        created_at            as CreatedAt,
        @Semantics.user.localInstanceLastChangedBy: true
        last_changed_by       as LastChangedBy,
        @Semantics.systemDateTime.lastChangedAt: true
        last_changed_at       as LastChangedAt,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        local_last_changed_at as LocalLastChangedAt,

        _Notification
  }
