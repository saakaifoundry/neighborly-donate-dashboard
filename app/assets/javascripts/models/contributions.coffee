Dashboard.Contribution = DS.Model.extend
  user: DS.belongsTo('user')
  project: DS.belongsTo('project')
  reward: DS.belongsTo('reward')
  value: DS.attr('string')
  anonymous: DS.attr('boolean')
  state: DS.attr('string')
  rights: DS.attr('object')
  payment_method: DS.attr('string')
  payment_service_fee: DS.attr('string')
  payment_service_fee_paid_by_user: DS.attr('boolean')
  payment_id: DS.attr('string')
  key: DS.attr('string')
  created_at: DS.attr('date')
  confirmed_at: DS.attr('date')
