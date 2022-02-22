# frozen_string_literal: true

class MembersController < ApplicationController
  load_and_authorize_resource

  has_control_panel_applet :steal_identity_applet,
                           if: -> { can? :steal_identity, Member }

  has_control_panel_applet :access_applet,
                           if: -> { true }

  @@wise_words = [
      'En reke om dagen er godt for magen.',
      'Hiv, og hoi! Snart er skatten vår!',
      'Langemann lurer alle, som en ulv i fåreklær!',
      'Vi jobber best når det dundrer og smeller rundt skuta vår!',
      'Kan du danse som en reke?',
      'Bli med til rekeland!',
      'Alle sjødyr er velkommen i rekeland!',
      'Lykken er et saftig rekesmørbrød.',
      'Bli med ut for å reke!',
      'Som du roper i skogen får du svar!',
      'Ekte reker lever på land.',
      'Har du noen gang sett en reke svømme 3000 meter?',
      'Reker trenger alltid ny rogn.',
      'Noen reker har aldri på seg t-skjorte.',
      'Reker elsker alle dyr i sjøen! <3',
      'Si hei til en reke!',
      'Hvilket sjødyr er du? En krabbe kanskje?',
      'Hvilket sjødyr er du? En blekksprut kanskje?',
      'Store fisker spiser aldri små fisker.',
      'Hopp i havet!',
      'Selv om sjødyr vokser opp til slutt blir de aldri glemt.',
      'En sprellende fisk burde få creds for å i hvertfall prøve å danse.',
      'Ville ha en reke som kjæledyr, men reker er frie dyr.',
      'Ikke alle pensjonister har skjegg faktisk.',
      'Adopter en reke i dag!',
      'Hvordan bruker egentlig en reke et tegnebrett?',
      'Reker ser alltid på film på søndager.',
      'Blub, blub!',
      'Jeg husker enda da jeg var rogn.',
      'Reker er flinke til å skrive!',
      'Reker er sjøens influencere.'
  ]

  def search
    @members = Member.where(
      "UPPER(fornavn) || ' ' || UPPER(etternavn) LIKE UPPER(?)" \
      ' OR UPPER(mail) LIKE UPPER(?) OR medlem_id = ?',
      "%#{params[:term].upcase}%",
      "%#{params[:term].upcase}%",
      params[:term].to_i
    )

    respond_to do |format|
      format.json do
        # Note the parentheses; they're necessary to achieve
        # the correct precedence for the do-block.
        render json: (@members.map do |member|
          { value: "#{member.id} - #{member.full_name}",
            label: "#{member.full_name} (#{member.mail})" }
        end)
      end
    end
  end

  def control_panel
    @applets = ControlPanel.applets(request).select(&:relevant?)
    @wise_words = @@wise_words.sample
  end

  def steal_identity_applet; end

  def steal_identity
    session[:member_id] = Member.find(params[:member_id]).id
    session[:applicant_id] = nil
    redirect_to root_path
  end

  def show_roles
  end

  def find_roles
    $roles = Member.find(params[:member_id]).roles
    $member = Member.find(params[:member_id]).full_name
    redirect_back(fallback_location: root_path)
  end
  def access_applet; end
end
