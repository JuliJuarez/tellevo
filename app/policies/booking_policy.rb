class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    # def resolve
    #   scope.all
    # end
  end

  def show?
    return true
  end

  def create?
    return true
  end

  def accept_booking?
    record.trip.user = user
  end

  def reject_booking?
    record.trip.user = user
  end
end
